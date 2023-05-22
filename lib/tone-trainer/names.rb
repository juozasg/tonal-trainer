require 'yaml'

module ToneTrainer
    module Names
        @@midimap = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'midi.yml'))
    
        def note_name(note_code)
            found = @@midimap['Note'].find { |k, v| v == note_code }
            return found[0] if found
        end
        
        def note_code(name)
            @@midimap['Note'][name]
        end
        
        NOTE_ON = @@midimap['Status']['Note On']
        NOTE_OFF = @@midimap['Status']['Note Off']
        PITCH_BEND = @@midimap['Status']['Pitch Bend']

        _INTERVALS = %w(root 5th 3rd 4th b3 2nd 7th 6th b7 tritone b2 b6)
        _SEMITONES = %w(0    7   4   5   3  2   11  9   10 6       1  8).map(&:to_i)
        
        INTERVALS = _INTERVALS + _INTERVALS.map { |i| "O+#{i}" }
        SEMITONES = _SEMITONES + _SEMITONES.map { |s| s + 8 }

    end
end
