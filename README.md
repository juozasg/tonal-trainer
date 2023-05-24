

## Environmental variables
Use these variables to skip MIDI device selection dialog and root note selection

|            |                                |
|------------|--------------------------------|
|`MIDI_IN`   | MIDI input device index        | 
|`MIDI_OUT`  | MIDI output device index       |
|`ROOT`      | root note name                 |
|`DIFFICULTY`| starting difficulty (default 3)|
|`LENGTH`    | starting length (default 3)    |


Example usage: 

`MIDI_IN=0 MIDI_OUT=2 ROOT=C4 ruby tone-trainer.rb`
