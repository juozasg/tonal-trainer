module ToneTrainer
    class Game
        include ToneTrainer::Names
        def initialize
            @midi_in, @midi_out, @midi = ToneTrainer.init_midi
            
            @input = UserInput.new(@midi_in)
            
            @seq_difficulty = 3
            @seq_length = 3
            
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
            else
                return
            end
            selected_intervals = '{' + INTERVALS[0...@seq_difficulty].join(', ') + '}'
            puts "Difficulty: " + "#{selected_intervals} ".blue + "x#{@seq_length}".magenta.italic.blink
        end
        
        def handle_note(note_code)
        end
        
        def run
            puts "running game..."
            puts "------"
            @input.print_prompt
            puts "------"
            
            
            
            # puts "Select root note..."
            # until @root
            #     @root_name = @input.get_user_input
            #     next unless @root_name.is_a? String
            #     @root = note_code(@root_name)
            #     puts "Root: " + "#{@root_name}".light_green + " (MIDI #{@root})".green
            # end
            
            loop do
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