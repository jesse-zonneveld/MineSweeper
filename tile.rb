class Tile
    DELTAS = [
        [-1, -1],
        [-1,  0],
        [-1,  1],
        [ 0, -1],
        [ 0,  1],
        [ 1, -1],
        [ 1,  0],
        [ 1,  1]
        ].freeze

    def initialize(board, pos)
        @board, @pos = board, pos
        @bombed = false
        @flagged = false
        @explored = false
        @adj_bomb_count = nil
        determine_type
        determine_bomb_count
    end

    attr_accessor :bomb_count, :pos

    def bombed?
        @bombed
    end

    def flagged?
        @flagged
    end

    def explored?
        @explored
    end

    def plant_bomb
        @bombed = true
    end

    def adj_tiles
        adj_coords = DELTAS.map do |(dx, dy)|
            x, y = @pos
            [x + dx, y + dy]
        end
        adj_coords.select do |(x, y)|
            x.between?(0, @board.size - 1) && y.between?(0, @board.size - 1)
        end
        adj_coords.map { |pos| @board[pos] }
    end

    def determine_bomb_count
        @adj_bomb_count = adj_tiles.count { |tile| tile.bombed? }
    end


    def explore
        return self if explored?
        return self if flagged?

        @explored = true
        if !bombed? && @adj_bomb_count == 0
            adj_tiles.each { |tile| tile.explore }
        end
        self
    end

    def inspect
        { pos: pos,
      bombed: bombed?,
      flagged: flagged?,
      explored: explored? }.inspect
    end

    def render
        if flagged?
            "F"
        elsif explored?
            @adj_bomb_count == 0 ? "_" : @adj_bomb_count.to_s
        else
            "*"
        end
    end

    def reveal
        if flagged?
            bombed? ? "F" : "f"
        elsif bombed?
            explored? ? "X" : "B"
        else
            @adj_bomb_count == 0 ? "_" : @adj_bomb_count.to_s
        end
    end

    def toggle_flag
        @flagged = !@flagged unless explored?
    end

    def flag
        @flagged = true
    end

end