module ToneTrainer
    class Game
        include ToneTrainer::Nomenclature
        def initialize
            @midi_in, @midi_out, @midi = ToneTrainer.init_midi

            
            @input = UserInput.new(@midi_in)
            
            @seq_difficulty = 3
            @seq_length = 3
            @total_score = 0

            @replays = 3

            
            # [root, 5th, 3rd, 4th, 7th, 6th, octave, 9th, 11th, 13th]
        end
        
        def handle_action(action_name)
            case action_name
            when :harder
                @seq_difficulty += 1 if @seq_difficulty < INTERVALS.length
            when :easier
                @seq_difficulty -= 1 if @seq_difficulty > 3
            when :longer
                @seq_length += 1 if @seq_length < 8
            when :shorter
                @seq_length -= 1 if @seq_length > 2
            when :replay
                return
            else
                return
            end
            
            print_difficulty
        end

        def replay
            @replays -= 1
            if @replays == 0
                puts "No replays".red
                return
            end
            puts "Replaying... (#{@replays} replays left)"
            @puzzle.replay
        end
        
        def print_difficulty
            selected_intervals = '{' + INTERVALS[0...@seq_difficulty].join(', ') + '}'
            score = @seq_difficulty * @seq_length;
            puts "Difficulty: " + "#{selected_intervals} ".blue + "x#{@seq_length}".magenta.italic.blink + "  (#{score.to_s.green} pts)"
        end

        
        def handle_note(note_code)
            if @puzzle && !@puzzle.solved?
                correct = @puzzle.guess!(note_code)
                if @puzzle.solved?
                    solved!
                    return
                end

                if !correct && @replays == 0
                    failed!
                    return
                end
                @puzzle.prompt(false)
            end
        end

        def solved!
            @score += @puzzle.score
        end

        def failed!
            @score -= @puzzle.score
        end

        def get_root
            # puts "Select root note..."
            # until @root
            #     @root_name = @input.get_user_input
            #     next unless @root_name.is_a? String
            #     @root = note_code(@root_name)
            # end
            
            @root_name = 'C3'
            @root = note_code(@root_name)
        end
        
        def run
            puts "running game..."
            puts "------"
            @input.print_prompt
            puts "------"

            get_root

            
            puts "Root: " + "#{@root_name}".light_green + " (MIDI #{@root})".green
            print_difficulty
            
            loop do
                @puzzle ||= Puzzle.new(@seq_difficulty, @seq_length, @root, @midi)
                received = @input.get_user_input
                
                if received.is_a? String
                    handle_note(note_code(received))
                elsif received.is_a? Symbol
                    handle_action(received)
                end
            end
        end
    end
end


# #   1.times do |oct|
# m.octave 3
# %w{C E G B}.each { |n| m.play n, 0.1 }
# #   end

# loop do
#     puts "waiting for input..."
#     n = input.gets
#     puts "got input: #{n}"
#     cc = n[0][:data][0]
#     note = n[0][:data][1]

#     m.play note, 1.6 if cc == 128
#     # m.note(note)
#     # m.off 
# end