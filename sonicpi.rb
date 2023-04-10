use_random_seed Time.now.to_i

length = 3
win_streak = 0
lose_count = 0

notes =  [:C, :B, :G]
extra_notes = [:E, :F, :D, :A]

define :reset_game do
  win_streak = 0
  lose_count = 0
end

define :harder do
  reset_game
  longer = one_in(2)
  if longer
    length += 1
  else
    notes.push extra_notes.shift
  end
  sample :loop_garzul, sustain: 3
  sleep 4
end

define :easier do
  reset_game
  shorter = one_in(2)
  if shorter
    length -= 1
  else
    extra_notes.unshift notes.pop
  end
  sample :ambi_glass_hum, sustain: 3
  sleep 4
end


live_loop :midi_piano do
  ##| use_real_time
  
  picked = []
  
  sample :bass_thick_c, sustain: 2
  ##| sleep 0.5
  synth :piano, note: [:C, :E, :G]
  sleep 2
  
  length.times do
    note = choose notes
    picked.push(note)
    synth :piano, note: note
    sleep 1
  end
  
  # get all the notes from midi
  # if win streak == 8
  # harder
  # if lose count == 8 easier
  
  
  
  
  puts(note_info(picked[0] + 12).midi_string)
  
  sample :vinyl_scratch
  sleep 3
end