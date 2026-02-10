extends Button
class_name SelectionButton

@export var menu_to_open : Control


# =================================================================================================


func _on_pressed() -> void:
	menu_to_open.visible = true
	get_parent().visible = false
