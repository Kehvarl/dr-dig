module Main
  class Game
    def initialize vars={}, args
      @background = build_background()
      @grid = build_grid()
      @tile_size = 32
    end

    def build_background
      out = []
      out << {x:0, y:576, w:1280, h:144, r:0, g:0, b:216}.solid!
      out << {x:0, y:0, w:1280, h:576, r:0, g:0, b:0}.solid!
      out
    end

    def create_tile(x, y, visible=true, block_movement=true, destroyable=true, hp=3)
      {x:x, y:y, visible:visible, block_movement:block_movement, destroyable:destroyable, hp:hp}
    end

    def build_grid(h=18, w:40)
      grid = []
      (0..h-1).each do |ph|
        (0..w-1).each do |pw|
          grid << create_tile(pw + 0, ph + 0, true, true, true)
        end
      end
      grid
    end

    def render_grid
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
      out << @background
      out << render_grid()
      out
    end

    def tick (args)
    end
  end
end
