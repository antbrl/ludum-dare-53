extends AudioStreamPlayer

@export var sounds: Array[AudioStream]

func play_random_sound():
	var index = randi() % len(sounds)
	stream = sounds[index]
	play()
