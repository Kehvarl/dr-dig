require 'app/sprite.rb'
module Main

  class Player < AnimSprite
    def initialize (x,y, is_player)
      super(x,y,is_player)
      @path= "sprites/ball.png"
      @w= 32
      @h= 32
      @tile_w= 32
      @tile_h= 32
      @vx = 2
      @vy = 2

      @current_pose = :idle
      @pose_list = {
        #Name: [Row, Frames, Repeat, [Next Anim Options]]
        idle: [0,8,1,[:idle]],
        in_air: [1,2,1, [:idle]],
        jump:   [2,3,1, [:idle]],
        land:   [3,4,1, [:idle]],
        shoot:  [4,4,1, [:idle]],
        jump2:  [5,6,1, [:idle]],
        hurt:   [6,4,1, [:idle]],
        coin:   [7,3,1, [:idle]],
        dash:   [8,1,1, [:idle]],
        walk:   [9,4,1, [:idle]]
      }

      @frame_duration = 10
      @frame_delay = 10
    end
  end
end
