extends Button
class_name SelectionButton

@export var ui_manager : UIManager
@export var menu_to_open : String


# =================================================================================================


func _on_pressed() -> void:
	ui_manager.proceed_menu(menu_to_open)
