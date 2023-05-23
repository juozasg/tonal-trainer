module ToneTrainer
    class UserInput
        include ToneTrainer::Nomenclature

        def initialize(input)
            @input = input
            
            @pw_up = false
            @pw_down = false
            @c_held = false
            @drop_c = false
        end
        
        def print_prompt
            puts "PW to increase/decrease interval challenge: [root, 5, 3, 4, b3, 2, 7, 6, b7, b5, b2, b6, octave + interval]"
            puts "C+PW to increase/decrease question length"
            puts "Move MW to replay the question"
            puts "4 wins streak (#{'++++'.green}) increases difficulty, 2 losses (#{'--'.red}) decreases"
            puts "Ctrl-C to exit"
        end

        def clear
            @input.clear_buffer
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
                tname = tone_name(full_name)
                
                # pp ['read input:', msg, data1, full_name, tname]
                
                case msg
                when CC
                    next unless data1 == CC_MW 
                    return :replay
                when NOTE_ON
                    @c_held = (tname == 'C')
                when NOTE_OFF
                    if @c_held
                        if tname == 'C'
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