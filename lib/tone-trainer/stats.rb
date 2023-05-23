require 'fileutils'
require 'yaml'
require 'csv'

module ToneTrainer
    class Stats
        attr_reader :alltime_score
        def initialize
            @dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'stats'))
            FileUtils.mkdir_p(@dir) unless Dir.exists?(@dir)
            pp @dir

            @score_file = File.join(@dir, 'score.csv')
            if !File.exists?(@score_file)
                File.open(@score_file, 'w') do |f|
                    f.puts "Date,Score"
                end
            end

            @alltime_score = CSV.read(@score_file, headers: true).map { |row| row['Score'].to_i }.inject(0, :+)
        end

        def add(score, good_semitones, bad_semitones)
            @alltime_score += score
            File.open(@score_file, 'a') do |f|
                f.puts "#{ts},#{score}"
            end
        end

        def ts
            Time.now.utc.to_s.sub(' UTC', '')
        end
    end
end