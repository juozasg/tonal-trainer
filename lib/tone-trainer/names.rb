require 'yaml'

module ToneTrainer
    module Names
   
        @@midimap = YAML.load_file(File.join(File.dirname(__FILE__), 'data', 'midi.yml'))
 
        
        def note_name(note_code)
            @@midimap['Note'].find { |k, v| v == note_code }[0]
        end
        
        def note_code(name)
            @@midimap['Note'][name]
        end
        
        NOTE_ON = @@midimap['Status']['Note On']
        NOTE_OFF = @@midimap['Status']['Note Off']
        PITCH_BEND = @@midimap['Status']['Pitch Bend']
    end
end
