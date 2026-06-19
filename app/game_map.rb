class Game_Map
  attr_accessor :w, :h, :grid, :viewport, :check_tile, :build_playfield, :draw_rt, :render
  def initialize
    @w = 40
    @h = 18
    @tile_size = 32
    @background = {r:0,g:64,b:196,a:255}
    @grid = []
    @viewport = {x:0,y:0,w:40,h:18}
  end

  def check_tile(x,y,climbing=false,falling=true)
    tile = @grid.select{|g| g.x == x and g.y == y}[0]
    return (climbing and tile.block_climb) or (falling and tile.block_fall)
  end

  def build_playfield(playfield_model)
    playfield_model[0].each do |p|
      (0..p.h-1).each do |ph|
        (0..p.w-1).each do |pw|
          @grid << {x: pw + p.x, y: ph + p.y, block_climb:true, block_fall:true}
        end
      end
    end
  end

  def draw_rt args
    args.outputs[:game_map].width = @w*16
    args.outputs[:game_map].height = @h*16
    args.outputs[:game_map].primitives << {x:0,y:0,w:(@w*@tile_size),h:(@h*@tile_size),
                                          **@background}.solid!

    args.outputs[:game_map].primitives << draw_playfield
  end

  def draw_playfield
    out = []
    @grid.each do |p|
      out << {x:p.x*@tile_size, y:p.y*@tile_size, w:@tile_size, h:@tile_size, path: "sprites/square/gray.png"}.sprite!
      if p.x == 0
        out << {x:79*@tile_size, y:p.y*@tile_size, w:@tile_size, h:@tile_size, path: "sprites/square/gray.png"}.sprite!
      end
      #if p.y == 0
      #  out << {x:p.x*16, y:44*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      #end
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
