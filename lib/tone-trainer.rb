require 'bundler/setup'


require 'unimidi'
require 'midi'
require 'colorize'


require 'tone-trainer/nomenclature'
require 'tone-trainer/init'
require 'tone-trainer/game'
require 'tone-trainer/user_input'
require 'tone-trainer/puzzle'


# pp String.colors                       # return array of all possible colors names
# pp String.modes

# [:black,
#     :light_black,
#     :red,
#     :light_red,
#     :green,
#     :light_green,
#     :yellow,
#     :light_yellow,
#     :blue,
#     :light_blue,
#     :magenta,
#     :light_magenta,
#     :cyan,
#     :light_cyan,
#     :white,
#     :light_white,
#     :default]
#    [:default, :bold, :italic, :underline, :blink, :swap, :hide]

module ToneTrainer
    VERSION = "0.5.0"

    def self.run
        @game = Game.new
        @game.run
    end
end


