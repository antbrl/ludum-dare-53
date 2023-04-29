extends AnimatableBody2D
signal crate_dropped

func _on_target_body_entered(body):
	emit_signal("crate_dropped")
