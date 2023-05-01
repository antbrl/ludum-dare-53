extends NinePatchRect

func _process(delta):
	if get_rect().size.y > 32:
		region_rect.position.x = 0
	else:
		region_rect.position.x = 32
