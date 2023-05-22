require 'bundler/setup'

$LOAD_PATH << './lib'


require 'game'
require 'colorize'
# run_game


pp String.colors                       # return array of all possible colors names
pp String.modes

puts "----"
print "C".green
print " "
print "E".red
print " "
print "?".yellow.blink
