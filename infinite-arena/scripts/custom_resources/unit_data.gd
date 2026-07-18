class_name UnitData
extends Resource

@export var unit_name : String
@export var unit_role : Role
@export var unit_stats : Stats = Stats.new() # Initializes a new Stats resource on UnitData creation
@export var move_list : Array[Move]
@export var hat : Equipment
@export var top : Equipment
@export var bottoms : Equipment
@export var weapon : Equipment
@export var accessory : Equipment
@export var item : Item


# =================================================================================================


func _initialize_data():
	# Set name
	
	unit_stats._initialize_stats(unit_role)
	
	for m in unit_role.starting_moves:
		pass
	
	for e in unit_role.starting_equipment:
		_equip_equipment(e)

func _learn_move(pending_move : Move, move_slot : int) -> void:
	move_list[move_slot] = pending_move
	
	var new : bool = _check_codex()
	if new == true:
		_update_codex()

func _equip_equipment(pending_equip : Equipment) -> void:
	match pending_equip.equip_type:
		Equipment.Equipment_Type.HAT:
			pass
		Equipment.Equipment_Type.TOP:
			pass
		Equipment.Equipment_Type.BOTTOM:
			pass
		Equipment.Equipment_Type.WEAPON:
			pass
		Equipment.Equipment_Type.ACCESSORY:
			pass
	
	var new : bool = _check_codex()
	if new == true:
		_update_codex()

func _equip_item(pending_item : Item) -> void:
	
	
	var new : bool = _check_codex()
	if new == true:
		_update_codex()

func _check_codex() -> bool:
	return true

func _update_codex() -> void:
	pass
