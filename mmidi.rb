
require 'bundler/setup'

require "unimidi"
# require "midi"

# # prompt the user to select an input and output

if UniMIDI::Input.all.length == 0
    puts "No MIDI input devices found"
    exit
elsif UniMIDI::Input.all.length == 1
    input = UniMIDI::Input.first.open
else
    input = UniMIDI::Input.gets
end

if UniMIDI::Output.all.length == 0
    puts "No MIDI output devices found"
    exit
elsif UniMIDI::Output.all.length == 1
    output = UniMIDI::Output.first.open
else
    output = UniMIDI::Output.gets
end


input = UniMIDI::Input.first.open
output = UniMIDI::Output.first.open


puts "input = #{input.name}"
puts "output = #{output.name}"

puts "-------"

m = MIDI::Session.new(output)


#   1.times do |oct|
m.octave 3
%w{C E G B}.each { |n| m.play n, 0.1 }
#   end

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
