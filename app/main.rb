

module Main
  def initialize args
    args.state.game_state = :menu

  end

  def tick args
    if args.state.tick_count == 0
      initialize args
    end
    case args.state.game_state
    when :menu
    end
  end
