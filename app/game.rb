module Main
  class Game
    def initialize vars={}, args
      @background = build_background()
      @grid = build_grid()
      @tile_size = 32
      @player = {x:40, y:18, moving:false}
      set_render(@player)
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
        if p.visible
          out << {x:p.x*@tile_size, y:p.y*@tile_size,
                  w:@tile_size, h:@tile_size,
                  path: "sprites/square/gray.png"}.sprite!
        end
      end
      out
    end

    def render
      out = []
      out << @background
      out << render_grid()
      out << {x:@player.render_pos.x, y:@player.render_pos.y,
              w: @tile_size, h:@tile_size, path:'sprites/circle/black.png'}.sprite!
      out
    end

    def get_tile(x, y)
      tile =  @grid.find{|t| (t.x == x and t.y == y)}
      if tile
        return tile
      end
      return create_tile(x, y, false, false, false, 0)
    end

    def dig(obj)
      supporting_tile = get_tile(obj.x, (obj.y - 1))
      supporting_tile.hp -= 1
      if supporting_tile.hp <= 0
        supporting_tile.block_movement = false
        supporting_tile.visible = false
      end
    end

    def can_fall?(obj)
      return false if obj.moving or (obj.y <= 0)
      supporting_tile = get_tile(obj.x, (obj.y - 1))
      return (not supporting_tile.block_movement)
    end

    def check_gravity(obj)
      if can_fall?(obj)
        start_move(obj, obj.x, (obj.y - 1))
      end
    end

    def can_move(obj, direction)
      case direction
      when :left
        tile = get_tile((obj.x - 1), obj.y)
        return (tile.hp <= 0 and not tile.block_movement)
      when :right
        tile = get_tile((obj.x + 1), obj.y)
        return (tile.hp <= 0 and not tile.block_movement)
      when :down
        tile = get_tile(obj.x, (obj.y - 1))
        return (tile.hp <= 0 and not tile.block_movement)
      end
      return false
    end

    def start_move(obj, to_x, to_y)
      obj.move_to = {x:to_x, y:to_y}
      obj.anim_to = {x:to_x * @tile_size, y:to_y * @tile_size}
      obj.moving = true
    end

    def set_render(obj)
      obj.render_pos = {x:obj.x * @tile_size, y:obj.y * @tile_size}
    end

    def do_move(obj)
      if obj.render_pos.x < obj.anim_to.x
        obj.render_pos.x += 2
      elsif obj.render_pos.x > obj.anim_to.x
        obj.render_pos.x -= 2
      elsif obj.render_pos.y < obj.anim_to.y
        obj.render_pos.y += 2
      elsif obj.render_pos.y < obj.anim_to.y
        obj.render_pos.y -= 2
      else
        obj.moving = false
        obj.x = obj.move_to.x
        obj.y = obj.move_to.y
        set_render(obj)
      end
    end


    def tick (args)
      #Check Gravity
      check_gravity(@player)

      if @player.moving
        do_move(@player)
      end
      if not @player.moving
        #Get Input
        if args.inputs.keyboard.key_up.down
          dig(@player)
        elsif args.inputs.keyboard.key_up.left
          if can_move(@player, :left)
            start_move(@player, @player.x - 1, @player.y)
          else
            dig(@player.x - 1, @player.y)
          end
        elsif args.inputs.keyboard.key_up.right
          if can_move(@player, :right)
            start_move(@player, @player.x + 1, @player.y)
          else
            dig(@player.x + 1, @player.y)
          end
        end
      end
      #Update Map
    end
  end
end
