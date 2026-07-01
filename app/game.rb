module Main
  class Game
    def initialize vars={}, args
      @background = build_background()
      @grid = build_grid()
      @tile_size = 32
      @player = {x:40, y:18, moving:false}
      start_move(@player, 20, 18)
    end

    def build_background
      out = []
      out << {x:0, y:576, w:1280, h:144, r:0, g:0, b:216}.solid!
      out << {x:0, y:0, w:1280, h:576, r:0, g:0, b:0}.solid!
      out
    end

    def create_tile(x, y, visible=true, block_movement=true, destroyable=true, hp=3)
      {x:x, y:y, visible:visible, block_movement:block_movement, destroyable:destroyable, hp:hp}
    end

    def build_grid(h=18, w:40)
      grid = []
      (0..h-1).each do |ph|
        (0..w-1).each do |pw|
          grid << create_tile(pw + 0, ph + 0, true, true, true)
        end
      end
      grid
    end

    def render_grid
      out = []
      @grid.each do |p|
        a = 255
        if not p.visible
          a = 0
        end
        out << {x:p.x*@tile_size, y:p.y*@tile_size,
                w:@tile_size, h:@tile_size, a:a,
                path: "sprites/square/gray.png"}.sprite!
      end
      out
    end

    def render
      out = []
      out << @background
      out << render_grid()
      out << {x:@player.anim_from.x, y:@player.anim_from.y,
              w: @tile_size, h:@tile_size, path:'sprites/circle/black.png'}.sprite!
      out
    end

    def can_fall?(obj)
      return if obj.falling or (obj.y <= 0)
      supporting_tile = @grid.find{|t| t.x = objx and t.y = obj.y-1}
      return supporting_tile.block_movement
    end

    def check_gravity(obj)
      if can_fall?(obj)
        start_move(obj, obj.x)#, obj.y -1)
      end
    end

    def start_move(obj, to_x, to_y)
      obj.move_to = {x:to_x, y:to_y}
      obj.anim_from = {x:obj.x * @tile_size, y:obj.y * @tile_size}
      obj.anim_to = {x:to_x * @tile_size, y:to_y * @tile_size}
      obj.moving = true
    end

    def do_move(obj)
      puts(obj)
      if obj.anim_from.x < obj.anim_to.x
        obj.anim_from.x += 2
      elsif obj.anim_from.x > obj.anim_to.x
        obj.anim_from.x -= 2
      elsif obj.anim_from.y < obj.anim_to.y
        obj.anim_from.y += 2
      elsif obj.anim_from.y < obj.anim_to.y
        obj.anim_from.y -= 2
      else
        obj.moving = false
        obj.x = obj.move_to.x
        obj.y = obj.move_to.y
      end
    end


    def tick (args)
      #Check Gravity
      if @player.moving
        do_move(@player)
      end
      #Get Input
      #Update Map
    end
  end
end
