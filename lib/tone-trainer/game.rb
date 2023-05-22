module ToneTrainer
    class Game
        def initialize
            @midi_in, @midi_out, @midi = ToneTrainer.init_midi

            @input = UserInput.new(@midi_in)
        end
            
        def run
            puts "running game..."
            puts "------"
            
            loop do
               puts @input.get_user_input
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