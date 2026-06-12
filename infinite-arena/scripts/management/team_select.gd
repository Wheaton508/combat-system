extends Node3D

@onready var input_blocker: Control = $CanvasLayer/InputBlocker
@onready var unit_info: Control = $CanvasLayer/UnitInfo
@onready var unit_1: ClickableUnit = $UnitHolder/ClickableUnit
@onready var unit_2: ClickableUnit = $UnitHolder2/ClickableUnit
@onready var unit_3: ClickableUnit = $UnitHolder3/ClickableUnit
@onready var animation_player_1: AnimationPlayer = $UnitHolder/AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $UnitHolder2/AnimationPlayer
@onready var animation_player_3: AnimationPlayer = $UnitHolder3/AnimationPlayer

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
	
	# Turn off InputBlocker
	input_blocker.visible = false

func _refresh_units() -> void:
	# Clear loaded_roles array
	loaded_roles.clear()
	
	# Put up input blocker
	input_blocker.visible = true
	
	# Move UnitHolders offscreen
	animation_player_1.play("exit_screen") # remember to flip units the right way when animating
	animation_player_2.play("exit_screen")
	animation_player_3.play("exit_screen")
	await animation_player_3.animation_finished
	
	# Change units
	unit_1._give_role(_get_random_role())
	unit_2._give_role(_get_random_role())
	unit_3._give_role(_get_random_role())
	
	await get_tree().create_timer(time_to_wait_between_units).timeout
	
	# Move UnitHolders back on screen
	animation_player_1.play("enter_screen")
	animation_player_2.play("enter_screen")
	animation_player_3.play("enter_screen")
	await animation_player_3.animation_finished
	
	# Take down input blocker
	input_blocker.visible = true

func _change_info_display (is_hover_start : bool) -> void:
	if is_hover_start:
		unit_info.visible = true
	else:
		unit_info.visible = false

func _get_random_role() -> Role:
	var random_role : Role
	var invalid_role : bool = true
	
	while invalid_role:
		random_role = role_resource_array.pick_random()
		if loaded_roles.has(random_role) == false and chosen_roles.has(random_role) == false:
			invalid_role = false
	
	loaded_roles.append(random_role) # Add to chosen roles at some point too. Probably when the role is chosen.
	
	return random_role
