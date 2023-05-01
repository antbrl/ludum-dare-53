extends AudioStreamPlayer

@export var sounds: Array[AudioStream]
@export var skip_frequency: float = 0.0

func play_random_sound():
	if randf() >= skip_frequency:
		var index = randi() % len(sounds)
		play_sound(index)

func play_sound(sound_index: int):
	stream = sounds[sound_index]
	play()
