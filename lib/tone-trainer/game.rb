module ToneTrainer
    class Game
        include ToneTrainer::Nomenclature
        def initialize
            @midi_in, @midi_out, @midi = ToneTrainer.init_midi
            
            @input = UserInput.new(@midi_in)
            
            @seq_difficulty = 3
            @seq_length = 3
            @total_score = 0

            @good_streak = 0
            @bad_streak = 0

            at_exit do
                puts "\nFINAL SCORE: #{@total_score.to_s.green}"
                @midi.all_off
            end
        end
        
        def handle_action(action_name)
            self.send(action_name)
            
            unless action_name == :replay
                @puzzle.prompt(false)
            end
        end
        
        def harder
            if @seq_difficulty < INTERVALS.length
                puts "Harder!"
                @seq_difficulty += 1 
                print_difficulty
            end
        end
        
        def easier
            if @seq_difficulty > 3
                puts "Easier..."
                @seq_difficulty -= 1
                print_difficulty
            end
        end
        
        def longer
            if @seq_length < 8
                puts "Longer!"
                @seq_length += 1 
                print_difficulty
            end
        end

        def shorter
            if @seq_length > 3
                puts "Shorter..."
                @seq_length -= 1 
                print_difficulty
            end
        end

        def adjust_difficulty
            if @good_streak > 2
                @good_streak = 0
                @bad_streak = 0
                rand > 0.5 ? harder : longer
            elsif @bad_streak > 2
                @good_streak = 0
                @bad_streak = 0
                if @seq_length <= 3
                    easier
                elsif @seq_difficulty <= 3
                    shorter
                else
                    rand > 0.5 ? easier : shorter
                end
            end
        end

        def replay
            @replays -= 1
            if @replays < 0
                failed!
                @input.clear # prevent accidental double-input
                return
            end
            puts "Replaying... (#{@replays} left)"
            @puzzle.replay
            @input.clear # prevent accidental double-input
        end
        
        def print_difficulty
            selected_intervals = '{' + INTERVALS[0...@seq_difficulty].join(', ') + '}'
            score = @seq_difficulty * @seq_length;
            puts "Difficulty: " + "#{selected_intervals} ".blue + "x#{@seq_length}".magenta.italic.blink + "  (#{score.to_s.green} pts)"
        end

        
        def handle_note(note_name, note_code)
            @midi.play(note_code, 0.5)
            if @puzzle && !@puzzle.solved?
                semitone = note_code - @root
                correct = @puzzle.guess!(semitone)
                if @puzzle.solved?
                    solved!
                    return
                end

                if !correct
                    puts note_name.red + " is incorrect".red
                    sleep 0.5
                    replay
                else
                    @puzzle.prompt(false)
                end
            end
        end

        def solved!
            @total_score += @puzzle.score
            puts "Solved! +#{@puzzle.score}".green + " pts"
            @bad_streak = 0
            @good_streak += 1
            new_game
        end

        def failed!
            @total_score -= @puzzle.score
            puts "Failed! -#{@puzzle.score}".red + " pts"

            @good_streak = 0
            @bad_streak += 1

            new_game
        end

        def new_game
            gstreak = ("+" * @good_streak).green
            bstreak = ("-" * @bad_streak).red
            puts "TOTAL SCORE: #{@total_score.to_s.green} " + " " + gstreak + bstreak
            if @puzzle
                puts "good: #{@puzzle.stats_good.inspect}"
                puts "bad: #{@puzzle.stats_bad.inspect}"
            end
            adjust_difficulty

            puts ""
            sleep 1
            generate_puzzle
        end

        def generate_puzzle
            @puzzle = Puzzle.new(@seq_difficulty, @seq_length, @root, @midi)
            @replays = 3
            @puzzle.prompt
        end


        def get_root
            if $debug         
                @root_name = 'C5'
                @root = note_code(@root_name)
            else
                puts "Select root note..."
                until @root
                    @root_name = @input.get_user_input
                    next unless @root_name.is_a? String
                    @root = note_code(@root_name)
                end
            end
            puts "Root: " + "#{@root_name}".light_green + " (MIDI #{@root})".light_white

            @midi.play(@root, 1)
        end
        
        def run
            puts "running game..."
            puts "------"
            @input.print_prompt
            puts "------"

            get_root

            
            new_game
            
            loop do
                received = @input.get_user_input
                
                if received.is_a? String
                    handle_note(received, note_code(received))
                elsif received.is_a? Symbol
                    handle_action(received)
                end
            end
        end
    end
end
