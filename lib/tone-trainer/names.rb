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

        _INTERVALS = %w(root 5 3 4 b3 2 7  6 b7 b5 b2 b6)
        _SEMITONES = %w(0    7 4 5 3  2 11 9 10 6  1  8).map(&:to_i)
        
        INTERVALS = _INTERVALS + _INTERVALS.map { |i| "o+#{i}" }
        SEMITONES = _SEMITONES + _SEMITONES.map { |s| s + 8 }

    end
end
