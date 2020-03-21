require "colorize"

class Player
    def initialize(board)
        @board = board
        @name = "player 1"
    end

    def get_prompt_choice
        puts "Press 'f' to place a flag, or press 'e' to explore, or press 's' to save game:".yellow
        print "=>".yellow
        choice = gets.chomp
        until valid_choice?(choice)
            choice = gets.chomp
        end
        choice
    end

    def get_prompt_coord
        puts "Please enter a coordinate seperated by a space (example: 2 5):".yellow
        print "=>".yellow
        coord = gets.chomp.split(" ").map(&:to_i)
        until valid_coord?(coord)
            puts "Please enter a #{"VALID".red} coordinate seperated by a space (example: 2 5):".yellow
            print "=>".yellow
            coord = gets.chomp.split(" ").map(&:to_i)
        end
        coord
    end

    def valid_choice?(choice)
        return true if choice == "f" || choice == "e" || choice == "s"
        false
    end

    def valid_coord?(coord)
        return false if !coord.is_a?(Array)
        return false if coord.length != 2
        return false if !coord[0].between?(0, @board.size - 1)
        return false if !coord[1].between?(0, @board.size - 1)
        true
    end

end


        
