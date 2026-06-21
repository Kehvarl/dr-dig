require 'app/game.rb'
require 'app/game_sprites.rb'
require 'app/game_map.rb'

module Main
  def initialize args
    args.state.game = Game.new({})
  end

  def tick args
    if args.state.tick_count == 0
      initialize args
    end
    args.state.game.tick(args)
    args.outputs.primitives << args.state.game.render()
  end
end
