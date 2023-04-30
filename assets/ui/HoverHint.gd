extends NinePatchRect

func _process(delta):
	if Time.get_ticks_msec() % 1000 < 500:
		region_rect.position.x = 0
	else:
		region_rect.position.x = 9
