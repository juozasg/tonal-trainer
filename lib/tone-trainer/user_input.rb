module ToneTrainer
    class UserInput
        include ToneTrainer::Names

        def initialize(input)
            @input = input
            
            @pw_up = false
            @pw_down = false
            @c_held = false
        end
        
        def prompt_user_input
            puts "Use pitchwheel to increase/decrease note pool: [root, 5th, 3rd, 4th, 7th, 6th, octave, 9th, 11th, 13th]"
            puts "Use C+pitchwheel to increase/decrease question length"
            puts "Ctrl-C to exit"
            puts "------"
        end
        
        # return nil, :harder, :easier, :shorter, :longer, 'C1'...'B8'
        def get_user_input
            @pw_up = true
            
            loop do
                n = @input.gets[0][:data]
                msg = n[0]
                code = n[1]
                data = n[2] # velocity or pitchwheel value
                full_name = note_name(code) # C4
                tone_name = full_name.sub(/-?\d/, '') # C
                
                # pp ['read input:', msg, code, full_name, tone_name]
                
                case msg
                when NOTE_ON
                    @c_held = (tone_name == 'C')
                when NOTE_OFF
                    @c_held = !(tone_name == 'C')
                    return full_name
                when PITCH_BEND
                    if n[2] == 64
                        @pw_up = false
                        @pw_down = false
                        next
                    end
                    
                    high = n[2] > 64
                    low = n[2] < 64
                    
                    next if high && @pw_up
                    if high && !@pw_up
                        @pw_up = true
                        return :harder
                    end
                    
                    next if low && @pw_down
                    if low = !@pw_down
                        @pw_down = true
                        return :easier
                    end
                end
            end
        end
    end
end