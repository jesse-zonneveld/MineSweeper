require_relative "board"
require_relative "player"
require 'yaml'
require 'colorize'

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
        #@cheat = false
    end

    def play
        system("clear")
        started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        run
        ended = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        time = ended - started
        if @board.won? #|| @cheat
            puts "It took you #{time.round} seconds to complete!".green
        end
        leaderboard(time.round)
    end

    def run
        puts "~~~~~~".yellow + "Welcome to MineSweeper".green + "~~~~~~~".yellow
        until @board.lost? || @board.won? #|| @cheat
            sleep(1)
            puts
            puts @board.render
            puts
            sleep(1)
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
            #@cheat = true
        end
        sleep(1)
        puts "you win!".green if @board.won?
        puts "you lose!".red if @board.lost?
        sleep(1)
    end

    def save_game
        puts "Enter filename to save at:".green
        print "=>".green
        filename = gets.chomp
        File.write(filename, YAML.dump(self))
    end

    def leaderboard(time)
        board = []
        puts "------TOP 10 SCORES------"
        sleep(2)
        File.open("leaderboard.txt", "a") { |file| file.puts time }
        File.open("leaderboard.txt", "r") { |file| file.each { |line| board << line.to_i } }
        board.sort.each.with_index { |score, i| puts "#{(i + 1).to_s.ljust(4)}" + "#{score} seconds".green }
    end

end

if $PROGRAM_NAME == __FILE__
    
    case ARGV.count
    when 0
        Game.new.play
    when 1
        YAML.load_file(ARGV.shift).play
    end
end