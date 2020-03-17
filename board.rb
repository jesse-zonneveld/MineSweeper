require "./tile.rb"

class Board
    def initialize
        @adj_increments = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]]
        @grid = Array.new(9) { Array.new(9, 0)}
        @bomb_positions = []
        @seen_positions = []
        populate
        
    end

    attr_reader :grid, :bomb_positions

    def populate
        @grid.map!.with_index do |row, row_i|
            row.map!.with_index do |col, col_i|
                col = Tile.new
                @bomb_positions << [row_i, col_i] if col.type == "bomb"
                col
            end
        end
    end

    def render_cheat
        print "    "
        @grid.each_index { |i| print "#{i}    " }
        puts
        @grid.each_with_index do |row, row_i|
            puts "#{row_i} #{row.map { |col| col.symbol }}"
        end
    end

    def render
        print "    "
        @grid.each_index { |i| print "#{i}    " }
        puts
        @grid.each_with_index do |row, row_i|
            puts "#{row_i} #{row.map { |col| col.flipped }}"
        end
    end

    def [](pos)
        x, y = pos
        @grid[x][y]
    end

    def []=(pos, value)
        x, y = pos
        @grid[x][y] = value
    end

    def reveal(pos)
        return false if self[pos].type == "bomb" 
        self[pos].flip
        @seen_positions << pos unless seen_pos?(pos)
        current_adj = get_adj(pos)
        new_adj = []
        until has_bomb?(new_adj)
            new_adj = []
            current_adj.each do |pos|
                self[pos].flip
                new_adj += get_adj(pos)
            end
            current_adj = new_adj
        end
    end

    def get_adj(pos)
        x, y = pos
        current_adj = []
        @adj_increments.each do |increment_pair|
            new_pos = [x + increment_pair[0], y + increment_pair[1]]
            current_adj << new_pos if valid_pos?(new_pos) && !seen_pos?(new_pos)
            @seen_positions << new_pos
        end
        current_adj
    end

    def has_bomb?(arr)
        (arr & @bomb_positions).any?
    end

    def valid_pos?(pos)
        x, y = pos
        return false if !x.between?(0, 8)
        return false if !y.between?(0, 8)
        true
    end

    def seen_pos?(pos)
        @seen_positions.include?(pos)
    end

end

b = Board.new
b.render_cheat
p b.bomb_positions
b.reveal([0,0])
b.render