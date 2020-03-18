require_relative "board"
require_relative "player"

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
            coord = @player.get_prompt_coord
            case choice
                when "f"
                    @board[coord].toggle_flag
                when "e"
                    @board[coord].explore
            end
            puts
        end
        puts "you win!" if @board.won?
        puts "you lose!" if @board.lost?
    end

end

if $PROGRAM_NAME == __FILE__
    game = Game.new
    game.run
end