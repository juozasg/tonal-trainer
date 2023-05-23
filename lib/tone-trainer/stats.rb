module ToneTrainer
    class Stats
        attr_reader :alltime_score
        def initialize
            @alltime_score = 9000
        end

        def add(score, good_semitones, bad_semitones)
            @alltime_score += score
        end
    end
end