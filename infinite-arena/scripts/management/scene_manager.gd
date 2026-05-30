extends Node
class_name SceneManager

@onready var current_scene_holder: Node = $CurrentSceneHolder

@export var initial_scene : String

var current_scene : Node


# =================================================================================================


func _ready():
	Global.scene_manager = self
	
	var init = load(initial_scene).instantiate()
	current_scene_holder.add_child(init)
	current_scene = init

func _load_scene(new_scene_path : String):
	if current_scene != null:
		# Fade out
		
		# Between-scene save handling will have to happen here as well
		current_scene.queue_free()
		
		var new = load(new_scene_path).instantiate()
		current_scene_holder.add_child(new)
		current_scene = new
		
		# Fade back in
	else:
		print("ERROR. scene_manager.current_scene never set.") # Debug
