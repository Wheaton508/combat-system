extends Control
class_name Menu

@export var default_menu : Control


# =================================================================================================


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("back"):
		default_menu.visible = true
		visible = false
