module ToneTrainer
    def self.init_midi
        if UniMIDI::Input.all.length == 0
            puts "No MIDI input devices found"
            exit
        elsif UniMIDI::Input.all.length == 1
            input = UniMIDI::Input.first.open
        else
            if $debug
                input = UniMIDI::Input.all[1].open
            else
                input = UniMIDI::Input.gets
            end
        end
        
        if UniMIDI::Output.all.length == 0
            puts "No MIDI output devices found"
            exit
        elsif UniMIDI::Output.all.length == 1
            output = UniMIDI::Output.first.open
        else
            if $debug
                output = UniMIDI::Output.all[1].open
            else
                output = UniMIDI::Output.gets
            end
        end
        
        midi = MIDI::Session.new(output)
        
        
        puts "input = #{input.name}"
        puts "output = #{output.name}"
        if midi
            puts "midi ready!"
        else
            exit
        end
        
        return input, output, midi
    end
end