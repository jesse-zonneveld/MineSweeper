require "./tile.rb"

class Board
    def initialize
        @grid = Array.new(9) { Array.new(9, 0)}
        populate
    end

    attr_reader :grid

    def populate
        @grid.map! do |row|
            row.map! do |col|
                col = Tile.new
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
end

b = Board.new
b.render