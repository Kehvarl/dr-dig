module Main
  class Game
    def initialize vars={}, args
      @player = Player.new(1280, 576, true)
      @player.move_to(640, 576, :idle)

      @world_w = 1280/16 #40
      @world_h = 576/16 #18
      @world = GameMap.new()
      @world.build_playfield
    end

    def render
      out = []
      out << {x:0, y:576, w:1280, h:144, r:0, g:0, b:216}.solid!
      out << {x:0, y:0, w:1280, h:576, r:0, g:0, b:0}.solid!
      out << @world.draw_playfield
      out << @player
      out
    end

    def tick args
      @player.tick(args, [], true)
    end
  end
end
