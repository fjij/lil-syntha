beat = 0.4

define :progression do |n1, n2, n3, n4, t|
  play n1, amp: 2
  sleep t
  play n2
  sleep t
  play n3
  sleep t
  play n4
  sleep t
end
in_thread(name: :bass) do
  use_synth :dsaw
  loop do
    play :C2, amp: 5, sustain: 8*beat, release: 0
    sleep 8*beat
    play :B1, amp: 5, sustain: 8*beat, release: 0
    sleep 8*beat
    play :Bb1, amp: 5, sustain: 8*beat, release: 0
    sleep 8*beat
    play :A1, amp: 5, sustain: 4*beat, release: 0
    sleep 4*beat
    play :B1, amp: 5, sustain: 4*beat, release: 0
    sleep 4*beat
  end
end
in_thread(name: :chords) do
  loop do
    use_synth :fm
    2.times do
      progression :C5, :Eb5, :G5, :Eb5, beat
    end
    2.times do
      progression :B4, :Eb5, :Gs5, :Eb5, beat
    end
    2.times do
      progression :Bb5, :Eb5, :A5, :Eb5, beat
    end
    1.times do
      progression :A5, :Eb5, :Ab5, :Eb5, beat
    end
    1.times do
      progression :B5, :Eb5, :C6, :Eb5, beat
    end
  end
end
in_thread(name: :perc) do
  loop do
    sample :drum_heavy_kick, amp: 8
    sample :drum_bass_hard, amp: 8
    sample :drum_tom_hi_soft, amp: 8, rate: 0.5, sustain: 0, release: 0.4
    sleep 2*beat
    with_fx :reverb do
      sample :drum_snare_hard, amp: 5, sustain: 0, release: 0.2
      sleep 1.5*beat
      sample :drum_snare_hard, amp: 5, sustain: 0, release: 0.2
      sleep 1*beat
      sample :drum_snare_hard, amp: 5, sustain: 0, release: 0.2
      sleep 0.5*beat
    end
    sample :drum_heavy_kick, amp: 8
    sleep 1*beat
    with_fx :reverb do
      sample :drum_snare_hard, amp: 5, sustain: 0, release: 0.2
      sleep 1*beat
    end
    #sample , amp: 5, sustain: 0, release: 0.1
    sleep 1*beat
  end
end
in_thread(name: :hihats) do
  loop do
    sample :drum_cymbal_closed, rate: 2, amp: 10
    sleep 0.5*beat
  end
end

in_thread(name: :openhats) do
  sleep 0.4
  loop do
    sample :drum_cymbal_open, amp: 10, sustain: 0, release: 0.3
    sleep 8*beat
  end
end

