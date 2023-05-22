require 'init'

def run_game
    input, output, m = init_midi


    puts "-------"

    loop do
        n = input.gets[0][:data]
        if n[0] == 224
            is_up = n[2] > 64
            is_down = n[2] < 64
            if is_up
                puts "up"
            elsif is_down
                puts "down"
            end
        end
        # $stdout.puts(n)
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