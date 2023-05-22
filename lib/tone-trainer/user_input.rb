module ToneTrainer
    class UserInput
        include ToneTrainer::Names

        attr_accessor :replay_possible

        def initialize(input)
            @input = input
            
            @pw_up = false
            @pw_down = false
            @c_held = false
            @drop_c = false

            @replay_possible = false
        end
        
        def print_prompt
            puts "PW to increase/decrease interval challenge: [root, 5, 3, 4, b3, 2, 7, 6, b7, b5, b2, b6, octave + interval]"
            puts "C+PW to increase/decrease question length"
            puts "Move MW to replay the question"
            puts "Ctrl-C to exit"
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
                when CC
                    next unless data1 == CC_MW 
                    return :replay if @replay_possible
                when NOTE_ON
                    @c_held = (tone_name == 'C')
                when NOTE_OFF
                    if @c_held
                        if tone_name == 'C'
                            @c_held = false 
                            if @drop_c # C was used as a modifier, not a note
                                @drop_c = false
                                next
                            end
                        end
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