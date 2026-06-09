class_name SceneManager
extends Node

enum Fade {IN, OUT}

@onready var current_scene_holder: Node = $CurrentSceneHolder
@onready var scene_transition: CanvasLayer = $SceneTransition
@onready var animation_player: AnimationPlayer = $SceneTransition/AnimationPlayer

@export var initial_scene : String

var current_scene : Node


# =================================================================================================


func _ready() -> void:
	Global.scene_manager = self
	
	var init = load(initial_scene).instantiate()
	current_scene_holder.add_child(init)
	current_scene = init
	
	_transition(Fade.IN)

func _load_scene(new_scene_path : String) -> void:
	if current_scene != null:
		await _transition(Fade.OUT)
		
		# Between-scene save handling will have to happen here as well
		
		current_scene.queue_free()
		var new = load(new_scene_path).instantiate()
		current_scene_holder.add_child(new)
		current_scene = new
		
		_transition(Fade.IN)
	else:
		print_debug("ERROR. scene_manager.current_scene never set.")

func _transition(fade_type : Fade) -> void:
	if fade_type == Fade.OUT:
		scene_transition.visible = true
		animation_player.play("fade_in_black")
		await animation_player.animation_finished
	else:
		animation_player.play("fade_out_black")
		await animation_player.animation_finished
		scene_transition.visible = false
