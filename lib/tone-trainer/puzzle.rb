module ToneTrainer
    class Puzzle
        include ToneTrainer::Nomenclature

        attr_reader :score, :stats_good, :stats_bad

        def initialize(difficulty, length, root, midi)
            @difficulty = difficulty
            @length = length
            @root = root
            @midi = midi

            @score = difficulty * length

            @correct_length = 0

            @seq = generate_seq

            @note_duration = 0.6
            @rest_duration = 0.2

            # interval => count
            @stats_good = {}
            @stats_bad = {}
        end

        def generate_seq
            selected_intervals = '{' + INTERVALS[0...@difficulty].join(', ') + '}'
            puts "#{selected_intervals} ".blue + "x#{@length}".magenta.italic.blink + "  (#{@score.to_s.green} pts)"
            
            pool = SEMITONES[0...@difficulty]
            seq = [0]
            (@length - 2).times do
                seq << pool.sample
            end
            seq << 0
        end

        def replay(sound = true)
            @score = (@score * 0.75).ceil
            @correct_length = 0

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
                    sleep @rest_duration unless i == @seq.length - 1
                end
            end
      
            puts ""
            # if sound
            #     puts "  (#{@score.to_s.green} pts)" 
            # else
            # end
        end

        def guess!(semitone)
            if @seq[@correct_length] == semitone
                # dont count first and last root notes in stats
                unless @correct_length == 0 || @correct_length == @seq.length - 1
                    @stats_good[semitone] ||= 0
                    @stats_good[semitone] += 1
                end
                @correct_length += 1
                return true
            else
                @stats_bad[semitone] ||= 0
                @stats_bad[semitone] += 1
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