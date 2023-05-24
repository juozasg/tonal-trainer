require 'fileutils'
require 'csv'

module ToneTrainer
    class Stats
        attr_reader :alltime_score
        attr_accessor :semitone_root
        def initialize()
            @dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'stats'))
            FileUtils.mkdir_p(@dir) unless Dir.exists?(@dir)

            @score_file = File.join(@dir, 'scores.csv')
            init_scores_file

            @good_semitones = {}
            @bad_semitones = {}

            (0..24).each do |st|
                @good_semitones[st] = 0
                @bad_semitones[st] = 0
            end

            @semitone_root = 0
            @semitones_file = File.join(@dir, 'semitones.csv')
            init_semitones_file

            at_exit do
                update_ratios
            end
    
            @alltime_score = CSV.read(@score_file, headers: true).map { |row| row['Score'].to_i }.inject(0, :+)
        end

        def add(score, good_semitones, bad_semitones, difficulty, length)
            ### alltime score
            @alltime_score += score
            File.open(@score_file, 'a') do |f|
                f.puts "#{ts},#{score},#{semitone_root},#{difficulty},#{length}"
            end

            good_semitones.each do |st, count|
                @good_semitones[st] += count
            end
            
            bad_semitones.each do |st, count|
                @bad_semitones[st] += count
            end
        end


        def init_scores_file
            if !File.exists?(@score_file)
                File.open(@score_file, 'w') do |f|
                    f.puts "Date,Score,Root,Difficulty,Length"
                end
            end
        end
        
        def init_semitones_file
            cols = (0..24).to_a.join(',')
            if !File.exists?(@semitones_file)
                File.open(@semitones_file, 'w') do |f|
                    f.puts "Date,Root,#{cols}"
                end
            end
        end

        def update_ratios
            ratios = {}
            (0..24).each do |st|
                total = @good_semitones[st] + @bad_semitones[st]
                if total > 0
                    ratios[st] = @good_semitones[st].to_f / total
                else
                    ratios[st] = 0
                end
            end

            cols = ratios.values.join(',')

            File.open(@semitones_file, 'a') do |f|
                f.puts "#{ts},#{@semitone_root},#{cols}"
            end
        end

        def ts
            Time.now.utc.to_s.sub(' UTC', '')
        end
    end
end