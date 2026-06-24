module Main
  class Game
    def initialize vars={}, args

      @world_w = 1280/16 #40
      @world_h = 576/16 #18
      @world = GameMap.new()
      @world.build_playfield

      @player = Player.new(40,18, 32, 32, true)
      @player.move_to(20,18, :idle)
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
      if !@world.tile_blocked?(@player.map.x, @player.map.y)
        puts @player.map
        @player.move_to(@player.map.x, @player.map.y + 1, :idle)
      end
    end

    def fall
      if ! @player.moving
        puts @player.map
        if !@world.tile_blocked?(@player.map.x, @player.map.y - 1)
          @player.move_to(@player.map.x, @player.map.y - 1, :idle)
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
