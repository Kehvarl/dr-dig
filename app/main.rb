require 'app/game.rb'
require 'app/game_sprites.rb'
require 'app/game_map.rb'

# gmae
#  game -world/map
#  sprites/entities
#  Input handling and dispatch

# All Tile to Pixel conversions are done by World.
#

# Update
# Maybe I should just start fresh instead of importing tools that I don't understand clearly
# Or fix my tools.
# But that's silly.

#no update
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
