module ToneTrainer
    class Puzzle
        include ToneTrainer::Nomenclature

        attr_reader :score

        def initialize(difficulty, length, root, midi)
            @difficulty = difficulty
            @length = length
            @root = root
            @midi = midi

            @score = difficulty * length

            @correct_length = 0

            @seq = [0, 1, 2, 3, 0] # TODO: generate
        end

        def replay
            @score = @score * 0.75

            prompt
        end
        
        def prompt(play = true)
            @seq.each_with_index do |st, i|
                note_code = @root + st
                note_name = note_name(note_code)
                tname = tone_name(full_name)

                if i < @correct_length
                    print_answered tname
                elsif i == @seq.length - 1
                    # last one is known to be root
                    print_unanswered tname
                else
                    print_unaswered '?'
                end

                if play
                    @midi.play note_code, 0.5
                    sleep 0.4
                end
            end

            puts "  (#{@score.to_s.green} pts)"
            # prompt for each note
        end

        def guess!(semitone)
            if @seq[@correct_length] == semitone
                @correct_length += 1
                return true
            else
                return false
            end
        end

        def solved?
            @correct_length == @seq.length
        end

        private
        def print_answered(str)
            print str.green + ' '
            $stdout.flush
        end

        def print_unaswered(str)
            print str.light_yellow.blink + ' '
            $stdout.flush
        end
    end
end