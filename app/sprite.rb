module Main
  class AnimSprite
    attr_sprite
    attr_accessor :pose_list, :current_pose, :current_frame, :x, :y, :dx, :dy, :moving, :vx, :vy

    def initialize(x,y, is_player=false)
      @is_player = is_player
      @vx = 1
      @vy = 1
      @x = x
      @y = y
      @moving = false
      @dx = x
      @dy = y
      @w = 64
      @h = 64
      @path= "sprites/circle/green.png"
      @angle= 0
      @tile_x=  0
      @tile_y=  0
      @tile_w= 80
      @tile_h= 80
      @flip_vertically = false
      @flip_horizontally = false

      @current_pose = :idle
      @current_frame = 0
      @frame_duration = 10
      @frame_delay = 10
      @countdown = 0
      @pose_list = {
        #Name: [Row, Frames, Repeat, [Next Anim Options]]
        idle: [0,1,1,[:idle]],
        walk: [0,1,1,[:idle]],
      }
    end

    def move_to(x,y,pose=:walk)
      @dx = x
      @dy = y
      @moving = true
      @current_pose = pose
    end

    def max_frame()
      @pose_list[@current_pose][1]
    end

    def check_collisions(entities)
      if @dx < 0
        vx = -@vx
      elsif @dx > 0
        vx = @vx
      else
        vx = 0
      end
      if @dy < 0
        vy = -@vy
      elsif @dy > 0
        vy = @vy
      else
        vy = 0
      end

      temp = {x:(@x+vx), y:(@y+vy), w:@w, h:@h}
      collisions = entities.select{|e| temp.intersect_rect?(e)}
      collisions
    end

    def move_tick(args, entities)
      collisions = check_collisions(entities)
      if @is_player
        collisions = []
      end

      if @dx > @x and collisions.size <= 1
        @x += @vx
        @flip_horizontally = false
      elsif @dx < @x and collisions.size <= 1
        @x -= @vx
        @flip_horizontally = true
      end
      if @dy > @y and collisions.size <= 1
        @y += @vy
      elsif @dy < @y and collisions.size <= 1
        @y -= @vy
      end
      if (@dx == @x and @dy == @y) or collisions.size >1
        @moving = false
        @flip_horizontally = false
        @current_pose = @pose_list[@current_pose][3].sample()
      end
    end

    def animation_tick(args)
      @frame_duration -= 1
      if @frame_duration <= 0
        @frame_duration = @frame_delay
        @current_frame += 1
        if @current_frame >= @pose_list[@current_pose][1]
          @current_frame = 0
          @countdown -= 1
          if @countdown <= 0
            if not @moving
              @current_pose = @pose_list[@current_pose][3].sample()
            end
            @countdown = @pose_list[@current_pose][2]
          end
        end
      end
      @tile_x = @current_frame*@tile_w
      @tile_y = @pose_list[@current_pose][0]*@tile_h
    end

    def tick(args, entities, allow_move = true)
      if @moving
        move_tick(args, entities)
      end
      animation_tick(args)
      if allow_move and not @moving and rand(1000) <= 1 and not @is_player
        move_to(rand(1216), rand(656))
      end
    end

    def bounding_box(color={r:255,g:0,b:0})
      {x:@x, y:@y, w:@w, h:@h, **color}.border!
    end
  end
end
