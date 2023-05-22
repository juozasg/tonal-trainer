require 'yaml'

@midimap = YAML.load_file(File.join(File.dirname(__FILE__), 'midi.yml'))

pp @midimap

def note_name(note_code)
    @midimap['Note'].find { |k, v| v == note_code }[0]
end

def note_code(name)
    @midimap['Note'][name]
end
