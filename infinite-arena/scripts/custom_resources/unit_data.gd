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
	unit_name = unit_role.role_name # this will be changed later
	
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
			if hat == null:
				_calc_equipment(pending_equip)
			else:
				_recalc_equipment(pending_equip, hat)
			hat = pending_equip
		Equipment.Equipment_Type.TOP:
			if top == null:
				_calc_equipment(pending_equip)
			else:
				_recalc_equipment(pending_equip, top)
			top = pending_equip
		Equipment.Equipment_Type.BOTTOM:
			if bottoms == null:
				_calc_equipment(pending_equip)
			else:
				_recalc_equipment(pending_equip, bottoms)
			bottoms = pending_equip
		Equipment.Equipment_Type.WEAPON:
			if weapon == null:
				_calc_equipment(pending_equip)
			else:
				_recalc_equipment(pending_equip, weapon)
			weapon = pending_equip
		Equipment.Equipment_Type.ACCESSORY:
			if accessory == null:
				_calc_equipment(pending_equip)
			else:
				_recalc_equipment(pending_equip, accessory)
			accessory = pending_equip
	
	_check_codex(pending_equip)

func _calc_equipment(new_equipment : Equipment): # Used when equipping and item to an empty slot
	unit_stats.atk += new_equipment.atk_buff
	unit_stats.def += new_equipment.def_buff
	unit_stats.mag += new_equipment.mag_buff
	unit_stats.res += new_equipment.res_buff
	unit_stats.spd += new_equipment.spd_buff
	
	# Any logic regarding equipment effects

func _recalc_equipment(new_equipiment : Equipment, old_equipment : Equipment): # Used when replacing an old piece of equipment with a new one
	unit_stats.atk = unit_stats.atk - old_equipment.atk_buff + new_equipiment.atk_buff
	unit_stats.def = unit_stats.def - old_equipment.def_buff + new_equipiment.def_buff
	unit_stats.mag = unit_stats.mag - old_equipment.mag_buff + new_equipiment.mag_buff
	unit_stats.res = unit_stats.res - old_equipment.res_buff + new_equipiment.res_buff
	unit_stats.spd = unit_stats.spd - old_equipment.spd_buff + new_equipiment.spd_buff
	
	# Any logic regarding equipment effects


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
