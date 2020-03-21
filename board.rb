require "./tile.rb"
require "byebug"

class Board
    ITEM_COL_WIDTH = 3
    
    def initialize(size, num_bombs)
        @size, @num_bombs = size, num_bombs
        @grid = []
        self.make_board
    end

    attr_reader :grid, :size, :num_bombs

    def make_board
        @grid = Array.new(@size) do |row|
            Array.new(@size) { |col| Tile.new(self, [row,col]) }
        end
        place_bombs
    end

    def place_bombs
        
        grid_positions = Array.new(@size) do |row|
            Array.new(@size) { |col| [row,col] }
        end

        bombs_placed = 0
        while bombs_placed < @num_bombs
            rand_pos = Array.new(2) { rand(@size) }
            if grid_positions.any? { |row| row.include?(rand_pos) }
                tile = self[rand_pos]
                tile.plant_bomb
                grid_positions.delete(rand_pos)
                bombs_placed += 1
            end
        end
    end

    def render(reveal = false)
        print "    "
        @grid.each.with_index { |_, i| print i.to_s.ljust(ITEM_COL_WIDTH)}
        puts
        @grid.map.with_index do |row, i|
            row.map do |tile|
                reveal ? tile.reveal : tile.render
            end.unshift(i.to_s.ljust(ITEM_COL_WIDTH)).join("")
        end.join("\n")
    end

    def reveal
        render(true)
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end

    def []=(pos, value)
        x, y = pos
        @grid[x][y] = value
    end

    def won?
        @grid.flatten.all? do |tile|
            if tile.bombed?
                tile.flagged? == true
            else
                tile.flagged? == false
            end
        end
    end

    def lost?
        @grid.flatten.any? do |tile|
            tile.bombed? && tile.explored?
        end
    end

end



