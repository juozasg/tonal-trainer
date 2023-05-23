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

            @seq = [0, 1, 0] # TODO: generate

            @note_duration = 0.2
            @rest_duration = 0.01
        end

        def replay(sound = true)
            @score = (@score * 0.75).ceil

            prompt(sound)
        end
        
        def prompt(sound = true)
            @seq.each_with_index do |st, i|
                note_code = @root + st
                note_name = note_name(note_code)
                tname = tone_name(note_name)

                if i < @correct_length
                    print_answered tname
                elsif i == @seq.length - 1 || i == 0
                    # last one is known to be root
                    print_unanswered tname, i == @correct_length
                else
                    print_unanswered '?', i == @correct_length
                end

                if sound
                    @midi.play note_code, @note_duration
                    sleep @rest_duration
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

        def print_unanswered(str, blink = false)
            if blink
                str = str.light_yellow.on_black.blink
            else
                str = str.light_yellow
            end
            print str + ' '
            $stdout.flush
        end
    end
end