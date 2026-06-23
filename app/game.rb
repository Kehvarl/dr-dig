module Main
  class Game
    def initialize vars={}, args
      @player = Player.new(1280, 576, true)

      @world_w = 1280/16 #40
      @world_h = 576/16 #18
      @world = GameMap.new()
      @world.build_playfield

      wx, wy = @world.get_coord(20, 18)
      @player.move_to(wx, wy, :idle)
    end

    def render
      out = []
      out << {x:0, y:576, w:1280, h:144, r:0, g:0, b:216}.solid!
      out << {x:0, y:0, w:1280, h:576, r:0, g:0, b:0}.solid!
      out << @world.draw_playfield
      out << @player
      out
    end

    def jump
      x, y = @world.get_tile(@player.x, @player.y)
      if !@world.tile_blocked?(x, y + 1)
        wx, wy = @world.get_coord(x, y + 1)
        @player.move_to(wx, wy+1, :idle)
      end
    end

    def fall
      if ! @player.moving
        x, y = @world.get_tile(@player.x, @player.y)
        if !@world.tile_blocked?(x, y)
          wx, wy = @world.get_coord(x, y - 1)
          @player.move_to(wx, wy+1, :idle)
        end
      end
    end

    def tick args
      @player.tick(args, [], true)
      fall()
      if args.inputs.keyboard.space
        jump()
      end
    end
  end
end
