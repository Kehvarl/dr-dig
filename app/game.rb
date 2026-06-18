module Main
  class Game
    def initialize vars={}
      @player = AnimSprite.new(640, 576, true)
      @player.path = "sprites/ball.png"
      @player.tile_w = 32
      @player.tile_h = 32
      @player.pose_list = {
        #Name: [Row, Frames, Repeat, [Next Anim Options]]
        idle: [0,8,1,[:idle]],
      }

      @world_w = 1280/16
      @world_h = 576/16
      @tiles = {}
    end

    def render
      out = []
      out << {x:0, y:576, w:1280, h:144, r:0, g:0, b:216}.solid!
      out << {x:0, y:0, w:1280, h:576, r:0, g:0, b:0}.solid!
      out << @player
      out
    end

    def tick args
      @player.tick(args, [], true)
    end
  end
end
