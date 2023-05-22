module ToneTrainer
    class UserInput
        include ToneTrainer::Names

        def initialize(input)
            @input = input
            
            @pw_up = false
            @pw_down = false
            @c_held = false
            @drop_c = false
        end
        
        def prompt_user_input
            puts "Use pitchwheel to increase/decrease note pool: [root, 5th, 3rd, 4th, 7th, 6th, octave, 9th, 11th, 13th]"
            puts "Use C+pitchwheel to increase/decrease question length"
            puts "Ctrl-C to exit"
            puts "------"
        end
        
        # return nil, :harder, :easier, :shorter, :longer, 'C1'...'B8'
        def get_user_input          
            loop do
                n = @input.gets[0][:data]
                # pp n
                msg = n[0]
                data1 = n[1]
                data2 = n[2] # velocity or pitchwheel value
                full_name = note_name(data1) # C4
                next unless full_name # sometimes bugs out and MIDI data byte is not 0-127
                tone_name = full_name.sub(/-?\d/, '') # C
                
                # pp ['read input:', msg, data1, full_name, tone_name]
                
                case msg
                when NOTE_ON
                    @c_held = (tone_name == 'C')
                when NOTE_OFF
                    @c_held = !(tone_name == 'C')
                    if @drop_c # C was used as a modifier, not a note
                        @drop_c = false
                        next
                    end
                    return full_name
                when PITCH_BEND
                    if data2 == 64
                        @pw_up = false
                        @pw_down = false
                        next
                    end
                    
                    high = data2 > 64
                    low = data2 < 64
                    
                    next if high && @pw_up
                    if high && !@pw_up
                        @pw_up = true
                        @drop_c = @c_held
                        return @c_held ? :longer : :harder
                    end
                    
                    next if low && @pw_down
                    if low = !@pw_down
                        @pw_down = true
                        @drop_c = @c_held
                        return @c_held ? :shorter : :easier
                    end
                end
            end
        end
    end
end