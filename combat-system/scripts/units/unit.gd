extends Node3D
class_name Unit

enum Position {PRIMARY, SECONDARY, BACKLINE}
enum Action {MOVE, ITEM, SWAP}

@export var unit_name : String

@export_group("Equipment")
@export var hat : Equipment
@export var top : Equipment
@export var bottoms : Equipment
@export var equipment_one : Equipment
@export var equipment_two : Equipment
@export var item : Item

@export_group("Moves")
@export var moves : Array[Move] = [null, null, null, null]

@export_group("Extra Data")
@export var role : Role

@export_group("Node References")
@export var animated_sprite : AnimatedSprite3D
@export var indicator :Node3D

# Unit stats. Directly affected by level ups and equipment.
var level := 1
var experience := 0
var hp : int
var atk : int
var def : int
var mag : int
var mag_def : int
var spd : int

# Buff/defbuff inflictions.
var atk_buff : int
var def_buff : int
var mag_buff : int
var mag_def_buff : int
var spd_buff : int

# Cooldowns for buffs/debuffs. Decrement at the end of the turn (minimum of zero), and get reset at the end of combat.
var atk_cd : int
var def_cd : int
var mag_cd : int
var mag_def_cd : int
var spd_cd : int

@export var current_position : Position # THIS WILL EVENTUALLY BE CHANGED WHEN I DO ACTUAL UNIT GENERATION. For now I have to set it manually.
var current_action : Action
var current_move : Move
var current_targets : Array[Unit]
var has_acted := false
var incapacitated := false
var protecting := false

var initialized := false


# =================================================================================================


# Set "has acted" for incapacitated units at the same time as backline units in case I ever add revives
func take_turn():
	has_acted = true
	
	match current_action:
		Action.MOVE:
			for u in current_targets:
				move_action(u, current_move) # I want to clean this up eventually, maybe even attack both targets simultaneously, but for now this works
		Action.ITEM:
			item_action()
		Action.SWAP:
			swap_action()
		_:
			print("ERROR. Ending turn.")

func move_action(target: Unit, move: Move):
	var damage_dealt : int
	var damage_healed : int
	var accuracy_check : int
	
	if move.accuracy == 101:
		accuracy_check = 101
	else:
		accuracy_check = randi_range(0, 100)
	
	if accuracy_check <= move.accuracy: # accuracy checks will have to be reworked to allow spread move targeting to work
		# alternatively make the animation happen first, then deal damage for each target?
		# targeting will also have to become an array which fucks with things a bit
		match move.move_type:
			move.Move_Type.PHYSICAL:
				if target.protecting == true:
					damage_dealt = 0
				else:
					var weakness = calculate_weakness(target, move)
					damage_dealt = int(((((((2 * ((level + target.level) / 2)) / 5) + 2) * move.power * ((atk * atk_buff) / ((target.def * target.def_buff) + 1))) / 50) + 2) * weakness * randf_range(0.9, 1.1))
					
					if damage_dealt < 1:
						damage_dealt = 1
				
				animated_sprite.play("Attack01")
				print(str(name) + " attacking " + str(target.name) + " with " + str(move.name) + " for " + str(damage_dealt) + "!")
			move.Move_Type.MAGIC:
				# Checks if move is healing or offensive magic
				if "Healing" in move.attack_types:
					damage_healed = int((10 + (mag * (1 + (move.power / 100)))) * randf_range(0.9, 1.1))
					if damage_healed < 10:
						damage_healed = 10
					animated_sprite.play("Attack01")
					print(str(name) + " healing " + str(target.name) + " with " + str(move.name) + " for " + str(damage_healed) + "!")
				else:
					if target.protecting == true:
						damage_dealt = 0
					else:
						var weakness = calculate_weakness(target, move)
						damage_dealt = int(((((((2 * ((level + target.level) / 2)) / 5) + 2) * move.power * ((mag * mag_buff) / ((target.mag_def * target.mag_def_buff) + 1))) / 50) + 2) * weakness * randf_range(0.9, 1.1))
						if damage_dealt < 1:
							damage_dealt = 1
					
					animated_sprite.play("Attack01")
					print(str(name) + " attacking " + str(target.name) + " with " + str(move.name) + " for " + str(damage_dealt) + "!")
			move.Move_Type.STATUS:
				move_effect(target, move)
				pass
			_:
				print("ERROR. Move selection failed.")
	else: 
		print(str(name) + " missed!")

func calculate_weakness(target: Unit, move: Move) -> float:
	var weakness_mod := 1.0
	var weakness_count := 0
	
	# Check weaknesses and set weakness_count accordingly
	for t in move.attack_types:
		if target.role.weaknesses.has(t):
			weakness_count += 1
	
	# Set weakness_modifier
	if weakness_count == 0:
		weakness_mod = 1.0
	elif weakness_count == 1:
		weakness_mod = 1.25
	else: # if weakness_count >= 2:
		weakness_mod = 1.5
	
	return weakness_mod

func move_effect(target: Unit, move: Move):
	match move.move_effect:
		Move.Move_Effect.BUFF:
			
			pass
		Move.Move_Effect.DEBUFF:
			
			pass
		Move.Move_Effect.PROTECT:
			print(str(name) + " is protecting themself!")
			protecting = true
		Move.Move_Effect.REDIRECT:
			# for each enemy, if target.current_target == PlayerUnit, target.current_target = self
			pass
		_:
			print("ERROR. Move effect invalid.")
	pass

func item_action():
	pass

func swap_action():
	pass

func reset_variables():
	current_move = null
	current_targets.clear()
	has_acted = false
	protecting = false
