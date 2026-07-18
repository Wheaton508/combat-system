extends Node3D

@onready var input_blocker: Control = $CanvasLayer/InputBlocker
@onready var unit_preview_panel: Control = $CanvasLayer/UnitPreviewPanel
@onready var unit_1: ClickableUnit = $ClickableUnit1
@onready var unit_2: ClickableUnit = $ClickableUnit2
@onready var unit_3: ClickableUnit = $ClickableUnit3
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var role_resource_array : Array[Role]
@export var time_to_wait_on_scene_load : float = 1.0 # Will be made constant once I find a good time
@export var time_to_wait_between_units : float = 1.0

var loaded_roles : Array[Role] # Will be checked in get_random_role to ensure players do not get repeat classes in a given set
var chosen_roles : Array[Role] # Same as above. Disallows players from getting classes they have already picked


# =================================================================================================


func _ready() -> void:
	# Connect to ClickableUnit signals
	unit_1.connect("unit_selected", _refresh_units)
	unit_1.connect("unit_hover", _change_info_display)
	unit_2.connect("unit_selected", _refresh_units)
	unit_2.connect("unit_hover", _change_info_display)
	unit_3.connect("unit_selected", _refresh_units)
	unit_3.connect("unit_hover", _change_info_display)
	
	# Wait, then load unit roles and move them on screen
	await get_tree().create_timer(time_to_wait_on_scene_load).timeout
	
	unit_1._give_role(_get_random_role())
	unit_2._give_role(_get_random_role())
	unit_3._give_role(_get_random_role())
	
	animation_player.play("enter_screen")
	await animation_player.animation_finished
	
	unit_1.animated_sprite_3d.play("idle")
	unit_2.animated_sprite_3d.play("idle")
	unit_3.animated_sprite_3d.play("idle")
	
	# Turn off InputBlocker
	input_blocker.visible = false

func _refresh_units() -> void:
	# Clear loaded_roles array
	loaded_roles.clear()
	
	# Put up input blocker and take down unit preview - currently bugged
	unit_preview_panel.visible = false
	input_blocker.visible = true
	
	# Move UnitHolders offscreen
	unit_1.animated_sprite_3d.play("walk")
	unit_2.animated_sprite_3d.play("walk")
	unit_3.animated_sprite_3d.play("walk")
	animation_player.play("exit_screen")
	await animation_player.animation_finished
	
	# Change units
	unit_1._give_role(_get_random_role())
	unit_2._give_role(_get_random_role())
	unit_3._give_role(_get_random_role())
	
	await get_tree().create_timer(time_to_wait_between_units).timeout
	
	# Move UnitHolders back on screen
	animation_player.play("enter_screen")
	await animation_player.animation_finished
	
	unit_1.animated_sprite_3d.play("idle")
	unit_2.animated_sprite_3d.play("idle")
	unit_3.animated_sprite_3d.play("idle")
	
	# Take down input blocker
	input_blocker.visible = false

func _change_info_display (is_hover_start : bool, role_resource) -> void:
	if is_hover_start:
		unit_preview_panel.current_role = role_resource
		unit_preview_panel.visible = true
	else:
		unit_preview_panel.visible = false

func _get_random_role() -> Role:
	var random_role : Role
	var invalid_role : bool = true
	
	while invalid_role:
		random_role = role_resource_array.pick_random()
		if loaded_roles.has(random_role) == false and chosen_roles.has(random_role) == false:
			invalid_role = false
	
	loaded_roles.append(random_role) # Add to chosen roles at some point too. Probably when the role is chosen.
	
	return random_role
