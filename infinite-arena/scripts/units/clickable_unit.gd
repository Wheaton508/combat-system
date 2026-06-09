class_name ClickableUnit
extends Node3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var area_3d: Area3D = $Area3D

@export var stored_role : Role

#const unit_data_ref = preload("res://scripts/custom_resources/unit_data.gd")


# =================================================================================================


func _ready() -> void:
	area_3d.connect("mouse_entered", _hover_unit_start)
	area_3d.connect("mouse_exited", _hover_unit_end)
	area_3d.connect("input_event", _select_unit)

func _instantiate(role_to_grant : Role):
	stored_role = role_to_grant
	animated_sprite_3d.sprite_frames = stored_role.ui_sprite
	animated_sprite_3d.play("Idle")

func _hover_unit_start() -> void:
	print_debug("Hover start.")

func _hover_unit_end() -> void:
	print_debug("Hover end.")

func _select_unit(_camera : Node, event : InputEvent, _event_position : Vector3, _normal : Vector3, _shape_idx : int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print_debug("Unit selected.")
		# Creats an instance of the UnitData resource. Will be saved to file and give to a unit
		var new_data : UnitData = UnitData.new()
		
		# Initializes data values on that unit resource
		
		
		# Saves new_data to the Global script. These units will be saved to file for:
			# Main Menu display when all three are chosen
			# Actual gameplay purposes when a bookmark is created. During gameplay, always reference the Global script.
		if Global.units_dict["Primary"] == null:
			Global.units_dict["Primary"] = new_data
			# Spawn in a second batch of units
		elif Global.units_dict["Secondary"] == null:
			# Spawn in a third batch of units
			Global.units_dict["Secondary"] = new_data
		elif Global.units_dict["Backline"] == null:
			Global.units_dict["Backline"] = new_data
			# Proceed with gameplay
		else:
			print_debug("ERROR. Global.units_dict is full.")
