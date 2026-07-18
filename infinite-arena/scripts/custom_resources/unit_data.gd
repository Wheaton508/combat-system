class_name UnitData
extends Resource

@export var unit_name : String
@export var unit_role : Role
@export var unit_stats : Stats = Stats.new() # Initializes a new Stats resource on UnitData creation
@export var move_list : Array[Move] = [null, null, null, null]
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
	
	for m in unit_role.starting_moves.size():
		_learn_move(unit_role.starting_moves[m], m)
	
	for e in unit_role.starting_equipment:
		_equip_equipment(e)

func _learn_move(pending_move : Move, move_slot : int) -> void:
	move_list[move_slot] = pending_move
	_check_codex(pending_move)

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
	
	_check_codex(pending_equip)

func _equip_item(pending_item : Item) -> void:
	item = pending_item
	_check_codex(pending_item)

func _check_codex(item_to_check) -> void:
	var save_game : SaveData = SafeResourceLoader.load(Global.save_manager.save_game_path) as SaveData
	
	if item_to_check is Move:
		var move : Move = item_to_check as Move
		if save_game.moves_dict[move.id] == false:
			save_game.moves_dict[move.id] = true
			ResourceSaver.save(save_game, Global.save_manager.save_game_path)
	elif item_to_check is Equipment:
		var equip : Equipment = item_to_check as Equipment
		if save_game.equipment_dict[equip.id] == false:
			save_game.equipment_dict[equip.id] = true
			ResourceSaver.save(save_game, Global.save_manager.save_game_path)
	elif item_to_check is Item:
		var new_item : Item = item_to_check as Item
		if save_game.item_dict[new_item.id] == false:
			save_game.item_dict[new_item.id] = true
			ResourceSaver.save(save_game, Global.save_manager.save_game_path)
	else:
		print_debug("ERROR. Item is not of a valid type.")
