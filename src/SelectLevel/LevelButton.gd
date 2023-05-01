extends Button

signal level_clicked(level: int)

var level_number

func init(level_number):
	self.level_number = level_number
	self.text = 'Level ' + str(level_number + 1)

func _on_pressed():
	emit_signal("level_clicked", self.level_number)
