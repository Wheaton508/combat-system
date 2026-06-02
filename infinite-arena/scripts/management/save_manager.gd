extends Node
class_name SaveManager


# =================================================================================================


func _ready() -> void:
	Global.save_manager = self

# Called the first time the game is booted up, and when the save file is deleted
func initialize_save_file() -> void:
	# if the save file doesn't exist, create it
	# set stats to initial values
	pass
