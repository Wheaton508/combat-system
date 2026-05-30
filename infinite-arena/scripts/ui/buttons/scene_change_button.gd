extends Button

@export var scene_path_to_load : String


# =================================================================================================


func _ready():
	self.connect("pressed", _on_pressed)

func _on_pressed():
	Global.scene_manager._load_scene(scene_path_to_load)
