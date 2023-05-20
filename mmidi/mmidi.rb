# gem install micromidi
# gem install unimidi


require "unimidi"
require "midi"

# # prompt the user to select an input and output

# @input = UniMIDI::Input.gets
# @output = UniMIDI::Output.gets
input = UniMIDI::Input.first.open
output = UniMIDI::Output.first.open

# pp @input

puts "input = #{input.name}"
puts "output = #{output.name}"
# pp @output

puts "playing..."

m = MIDI::Session.new(output)
# pp UniMIDI.constants
# pp output.methods
# exit


#   1.times do |oct|
m.octave 3
%w{C E G B}.each { |n| m.play n, 0.1 }
#   end

# pp input
loop do
    puts "waiting for input..."
    n = input.gets
    puts "got input: #{n}"
    cc = n[0][:data][0]
    note = n[0][:data][1]
    
    m.play note, 1.6 if cc == 128
    # m.note(note)
    # m.off 

end
