require_relative "board"
require_relative "player"
require 'yaml'

class Game
    LAYOUTS = {
    small: { grid_size: 9, num_bombs: 10 },
    medium: { grid_size: 16, num_bombs: 40 },
    large: { grid_size: 32, num_bombs: 160 } # whoa.
  }.freeze
    def initialize(size = :medium)
        layout = LAYOUTS[size]
        @board = Board.new(layout[:grid_size], layout[:num_bombs])
        @player = Player.new(@board)
    end

    def run
        puts "welcome to MineSweeper"
        until @board.lost? || @board.won?
            sleep(2)
            puts
            puts @board.render
            puts
            sleep(2)
            choice = @player.get_prompt_choice
            puts
            sleep(1)
            case choice
                when "f"
                    coord = @player.get_prompt_coord
                    @board[coord].toggle_flag
                when "e"
                    coord = @player.get_prompt_coord
                    @board[coord].explore
                when "s"
                    save_game
            end
            puts
            system("clear")
        end
        puts "you win!" if @board.won?
        puts "you lose!" if @board.lost?
    end

    def save_game
        puts "Enter filename to save at:"
        filename = gets.chomp
        File.write(filename, YAML.dump(self))
    end

end

if $PROGRAM_NAME == __FILE__
    
    case ARGV.count
    when 0
        Game.new.run
    when 1
        YAML.load_file(ARGV.shift).run
    end
end