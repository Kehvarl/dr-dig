class GameMap
  attr_accessor :w, :h, :grid, :viewport, :check_tile, :build_playfield, :draw_rt, :render
  def initialize
    @w = 40
    @h = 18
    @tile_size = 32
    @background = {r:0,g:64,b:196,a:255}
    @grid = []
    @viewport = {x:0,y:0,w:40,h:18}
  end

  def create_tile(x, y, visible=true, block_movement=true, destroyable=true)
    {x:x, y:y, visible:visible, block_movement:block_movement, destroyable:destroyable}
  end

  def tile_blocked?(x,y)
    tiles = @grid.select{|g| g.x == x and g.y == y}
    return tiles.any? { |t| t.block_movement  }
  end

  def dig_tile(x,y)
    @grid=  @grid.excluding{ |t| t.x == x and t.y == y and t.destroyable == true }
  end

  def build_playfield
    (0..@h-1).each do |ph|
      (0..@w-1).each do |pw|
        @grid << create_tile(pw + 0, ph + 0, true, true, true)
      end
    end
  end

  def draw_rt args
    args.outputs[:game_map].width = @w*16
    args.outputs[:game_map].height = @h*16
    args.outputs[:game_map].primitives << {x:0,y:0,w:(@w*@tile_size),h:(@h*@tile_size),
                                          **@background}.solid!

    args.outputs[:game_map].primitives << draw_playfield()
  end

  def draw_playfield
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
    out << {x:0,y:0,w:1280,h:720,
            source_x:@viewport.x*@tile_size,source_y:@viewport.y*@tile_size,
            source_w:@viewport.w*@tile_size,source_h:@viewport.h*@tile_size,
            path: :game_map }.sprite!
    out
  end

  def serialize
    {w:@w, h:@h, background:@background, grid:@grid, viewport:@viewport}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end
