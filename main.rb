# Hack the North 2019
# note: Sample pack not included

s_808 = "~/Samples/808s"
s_clap = "~/Samples/Claps"
s_hihat = "~/Samples/HiHats"
s_kick = "~/Samples/Kicks"
s_openhat = "~/Samples/Open Hats"
s_snare = "~/Samples/Snares"

n_808 = rand_i(7)
n_clap = rand_i(9)
n_hihat = rand_i(10)
n_kick = rand_i(10)
n_openhat = rand_i(8)
n_snare = rand_i(14)

useful_synths =
[:blade, :bnoise, :chipbass, :chiplead, :dpulse, :dsaw, :dtri, :fm, :pretty_bell, :growl, :hollow, :hoover, :piano, :pluck, :prophet, :pulse, :saw, :sine, :supersaw, :tb303, :tech_saws, :tri, :zawa]

# Load samples
sample s_808, n_808, amp: 0
sample s_clap, n_clap, amp: 0
sample s_hihat, n_hihat, amp: 0
sample s_kick, n_kick, amp: 0
sample s_openhat, n_openhat, amp: 0
sample s_snare, n_snare, amp: 0
sleep 0.5

# Song Properties

tp = rrand_i(-18, 0) #transpose

bpm = rrand(120, 170)
beat = 60.0/bpm

# test
tp_808 = [-2, 0, 0, 0, 0, 0, 1, 0]

# Chord Progression

define :choose_note do
  return choose([:C, :F, :G, :A])
end

define :get_sample_transpose do |note|
  if note == :C
    return 0
  end
  if note == :D
    return 2
  end
  if note == :E
    return 4
  end
  if note == :F
    return 5
  end
  if note == :G
    return 7
  end
  if note == :A
    return 9
  end
end

define :choose_chord_type do
  return choose([:major, :minor, :minor])
end

ch_count = rrand_i(3, 5)
ch_roots = []
ch_sample_transpose = []
ch_chords = []
ch_chord_type = []
ch_scales = []
ch_durations = []

ch_broken = choose([true, false])
ch_broken = true

ch_count.times do
  note = choose_note
  ch_roots << note
  ch_sample_transpose << get_sample_transpose(note)
end

i = 0
ch_count.times do
  chord_type = choose_chord_type
  ch_chord_type = chord_type
  ch_chords << chord(ch_roots[i], chord_type)
  ch_scales << scale(ch_roots[i], chord_type)
  i = i + 1
end

if ch_count == 3
  ch_durations = choose([
    [16*beat, 8*beat, 8*beat],
    [8*beat, 16*beat, 8*beat],
    [8*beat, 8*beat, 16*beat]
  ])
end

if ch_count == 4
  ch_durations = [8*beat, 8*beat, 8*beat, 8*beat]
end

if ch_count == 5
  ch_durations = choose([
    [4*beat, 4*beat, 8*beat, 8*beat, 8*beat],
    [8*beat, 4*beat, 4*beat, 8*beat, 8*beat],
    [8*beat, 8*beat, 4*beat, 4*beat, 8*beat],
    [8*beat, 8*beat, 8*beat, 4*beat, 4*beat]
  ])
end

# Melodic Patterns

define :choose_subrhythm_pattern do
  return choose([
    [1, 1, 2, 4],
    [1, 2, 1, 4],
    [2, 1, 1, 4],
    [4, 1, 1, 2],
    [4, 1, 2, 1],
    [4, 2, 1, 1],
    [2, 2, 4],
    [2, 4, 2],
    [4, 4]
  ])
end

define :choose_subrhythm do |beats|
  if beats == 1
    return choose([
      [1*beat],
      [0.5*beat, 0.5*beat]
    ])
  end
  if beats == 2
    return choose([
      [2*beat],
      [1.5*beat, 1*beat],
      [0.5*beat, 1*beat, 0.5*beat],
      [0.5*beat, 1.5*beat]
      [0.5*beat, 0.5*beat, 1*beat]
    ])
  end
  if beats == 4
    return choose([
      [1.5*beat, 1.5*beat, 1*beat],
      [3*beat, 1*beat],
      [2.5*beat, 0.5*beat, 1*beat],
      [0.5*beat, 3*beat, 0.5*beat]
    ])
  end
end


define :generate_close_note do |n|
  x = n + rrand_i(-2, 2)
  if x < 0
    x = 0
  end
  if x > 5
    x = 5
  end
  return x
end

define :generate_pattern do |t_scale|
  pattern = []
  n = choose([0, 4])
  srp = choose_subrhythm_pattern
  i = 0
  srp.length.times do
    sr = choose_subrhythm(srp[i])
    2.times do
      j = 0
      sr.length.times do
        pattern << [n, sr[j]*t_scale]
        n = generate_close_note(n)
        j = j + 1
      end
    end
    i = i + 1
  end
  return pattern
end

define :pattern_deep_copy do |pattern_og|
  pattern_new = []
  i = 0;
  pattern_og.length.times do
    pattern_new << pattern_og[i].clone
  end
  return pattern_new
end

define :mutate_pattern do |pattern, t_scale|
  pattern_mut = []
  t_elapsed = 0
  i = 0
  while t_elapsed < 4*beat*t_scale and i < pattern.length
    nt = pattern[i]
    pattern_mut << nt
    t_elapsed = t_elapsed + nt[1]
    i = i + 1
  end
  if i < pattern.length
    n_initial = pattern[i][0]
    n_final = choose([0, 4])
  end
  while i < pattern.length
    nt = pattern[i]
    nt[0] = pattern_mut[i - 1][0]
    if nt[0] > n_final
      nt[0] = nt[0] - rrand_i(1, 2)
      if nt[0] < n_final
        nt[0] = n_final
      end
    end
    if nt[0] < n_final
      nt[0] = nt[0] + rrand_i(1, 2)
      if nt[0] > n_final
        nt[0] = n_final
      end
    end
    if i == pattern.length - 1
      nt[0] = n_final
    end
    pattern_mut << nt
    i = i + 1
  end
  return pattern_mut
end

define :pattern_add_rests do |pattern|
	i = 0
	pattern.length.times do
		if rand_i(9) < 3
			pattern[i][0] = -1
		end
	end
end

define :full_pattern do
	pattern = []
	t_scale = choose([1, 2, 4])
	p_a = generate_pattern(t_scale)
	p_a_copy = pattern_deep_copy(p_a)
	p_b = mutate_pattern(p_a_copy, t_scale)
	if t_scale == 1
	  pattern = choose([
	   p_a + p_b + p_a + p_b,
	   p_a + p_a + p_a + p_b
	  ])
	end
	if t_scale == 2
	  pattern = choose([
	   p_a + p_a,
	   p_a + p_b
	  ])
	end
	if t_scale == 4
	  pattern = choose([p_a, p_b])
	end
	return pattern
end

m_pattern = full_pattern
v_pattern = full_pattern

m_synth = choose(useful_synths)
v_synth = choose(useful_synths)

m_lyrical = choose([true, false])
v_lyrical = !m_lyrical

ch_synth = choose(useful_synths)


# Playing Instruments

vol_beat = 1.0

define :play_beat1 do
  # Duration: 8 beats
  # DU. TS. TS-TS DU TS.
  sample s_kick, n_kick, amp: 4*vol_beat
  sleep 2*beat

  with_fx :reverb do
    sample s_snare, n_snare, amp: 1*vol_beat, sustain: 0, release: 0.2
    sleep 1.5*beat
    sample s_snare, n_snare, amp: 1*vol_beat, sustain: 0, release: 0.2
    sleep 1*beat
    sample s_snare, n_snare, amp: 1*vol_beat, sustain: 0, release: 0.2
    sleep 0.5*beat
  end

  sample s_kick, n_kick, amp: 8
  sleep 1*beat

  with_fx :reverb do
    sample s_snare, n_snare, amp: 1*vol_beat, sustain: 0, release: 0.2
    sleep 2*beat
  end
end

define :play_beat2 do
  # Duration: 8 beats
  2.times do
    sample s_kick, n_kick, amp: 4*vol_beat
    sleep 2*beat
    with_fx :reverb do
      sample s_snare, n_snare, amp: 1*vol_beat, sustain: 0, release: 0.2
      sleep 2*beat
    end
  end
end

vol_hihat = 1.0

define :play_hihat do
  # Duration: 0.5 beats
  sample s_hihat, n_hihat, amp: 0.8*vol_hihat
  sleep 0.5*beat
end

vol_openhat = 1.0

define :play_openhat do
  # Duration: 8 beats
  sleep 1*beat
  sample s_openhat, n_openhat, amp: 1*vol_openhat
  sleep 7*beat
end

vol_melody = 1.0

define :play_melody do |pattern_play, synth, lyrical, follow_chords|
  # Duration: 32 beats
  use_synth synth
  c = 0
  i = 0
  (pattern_play.length).times do
    if follow_chords == true
      c = ch_current
    end
		if pattern_play[i][0] >= 0
	    if lyrical == true
	      play ch_scales[c][pattern_play[i][0]], amp: vol_melody, attack: 0, sustain: pattern_play[i][1], release: 0
	    else
	      play ch_scales[c][pattern_play[i][0]], amp: vol_melody, attack: 0
	    end
		end
    sleep pattern_play[i][1]
    i = i + 1
  end
end

vol_chords = 1.0

define :play_chord_piece do |current_chord|
  # Duration: 8-16 beats
  use_synth ch_synth
	if ch_broken
		(ch_durations[current_chord]/(beat*4)).times do
	  	play play_pattern_timed ch_chords[current_chord] + [ch_chords[1]], 1*beat, amp: 0.7*vol_chords
		end
	else
		play ch_chords[current_chord], amp: 0.5*vol_chords, attack: 0, sustain: ch_durations[current_chord]
	  sleep ch_durations[current_chord]
	end
end

vol_808 = 1.0

define :play_808 do |current_chord|
  # Duration: 8-16 beats
  sample s_808, n_808, rpitch: ch_sample_transpose[current_chord] + tp_808[n_808] + tp, amp: 6*vol_808
  sleep ch_durations[current_chord]
end

# Test Play Song
song = [
	[1, 1, 0, 0, 1, 1, 0, 0], #main
	[0, 0, 1, 1, 0, 0, 0, 0], #verse
	[0, 1, 1, 1, 1, 1, 1, 1], #beat (open + hihat)
	[0, 1, 1, 1, 0, 0, 1, 0], #808s
	[1, 1, 1, 0, 1, 1, 1, 0] #chords
]

use_transpose tp + choose([-12, 0])

x = 0
ch_current = 0
loop do
	in_thread do
    # chord counter
    ch_current = 0
    ch_count.times do
      sleep ch_durations[ch_current]
      ch_current = ch_current + 1
    end
	end

	if song[0][x] == 1
		in_thread do
	      play_melody(m_pattern, m_synth, m_lyrical, false)
		end
	end

	if song[1][x] == 1
		in_thread do
	      play_melody(v_pattern, v_synth, v_lyrical, false)
		end
	end

	if song[4][x] == 1
		in_thread do
		  ch_count.times do
				use_transpose tp - 24
		    play_chord_piece(ch_current)
		  end
		end
	end

	if song[3][x] == 1
		in_thread do
		  ch_count.times do
		    play_808(ch_current)
		  end
		end
	end

	if song[2][x] == 1
		in_thread do
	    4.times do
	      play_beat1
	    end
		end

		in_thread do
	    64.times do
	      play_hihat
	    end
		end

		in_thread do
		  4.times do
	      play_openhat
		  end
		end
	end

	sleep beat*32
	x = x + 1
end
