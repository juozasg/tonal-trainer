require 'yaml'

module ToneTrainer
    module Nomenclature
        @@midimap = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'midi.yml'))
    
        def note_name(note_code)
            found = @@midimap['Note'].find { |k, v| v == note_code }
            return found[0] if found
        end

        def tone_name(name)
            name.sub(/-?\d/, '') # C
        end
        
        def note_code(name)
            @@midimap['Note'][name]
        end
        
        NOTE_ON = @@midimap['Status']['Note On']
        NOTE_OFF = @@midimap['Status']['Note Off']
        PITCH_BEND = @@midimap['Status']['Pitch Bend']
        CC = @@midimap['Status']['Control Change']
        CC_MW = @@midimap['Control Change']['Modulation Wheel']

        _INTERVALS = %w(root 3rd 5th 4th b3 2nd  6th 7th b7 #4th b2 b6)
        _SEMITONES = %w(0    4   7   5   3  2    9   11  10 6    1  8).map(&:to_i)
        
        INTERVALS = _INTERVALS + _INTERVALS.map { |i| "O+#{i}" }
        SEMITONES = _SEMITONES + _SEMITONES.map { |s| s + 8 }

    end
end
