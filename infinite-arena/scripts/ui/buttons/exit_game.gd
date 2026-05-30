extends Button


# =================================================================================================


func _ready():
	self.connect("pressed", _on_pressed)

func _on_pressed():
	# Will eventually require save-handling logic probably
	get_tree().quit()
