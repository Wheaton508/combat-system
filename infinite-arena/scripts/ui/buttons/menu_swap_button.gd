extends Button
 
@export var menu_to_open : Control
@export var menu_to_close : Control


# =================================================================================================


func _ready():
	self.connect("pressed", _on_pressed)

func _on_pressed():
	menu_to_open.visible = true
	menu_to_close.visible = false
