require 'bundler/setup'


require 'unimidi'
require 'midi'
require 'colorize'


require 'tone-trainer/names'
require 'tone-trainer/init'
require 'tone-trainer/game'
require 'tone-trainer/user_input'

module ToneTrainer
    VERSION = "0.5.0"

    def self.run
        @game = Game.new
        @game.run
    end
end


# pp String.colors                       # return array of all possible colors names
# pp String.modes

# puts "----"
# print "C".green
# print " "
# print "E".red
# print " "
# print "?".yellow.blink
