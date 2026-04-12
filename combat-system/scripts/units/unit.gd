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
var res : int
var spd : int

var hp_growth : int
var atk_growth : int
var def_growth : int
var mag_growth : int
var res_growth : int
var spd_growth : int

# Buff/defbuff inflictions.
var atk_buff : int
var def_buff : int
var mag_buff : int
var res_buff : int
var spd_buff : int

# Cooldowns for buffs/debuffs. Decrement at the end of the turn (minimum of zero), and get reset at the end of combat.
var atk_cd : int
var def_cd : int
var mag_cd : int
var res_cd : int
var spd_cd : int

# current_pos will only be used for initializing units in combat_setup
@export var current_position : Position # THIS WILL EVENTUALLY BE CHANGED WHEN I DO ACTUAL UNIT GENERATION. For now I have to set it manually.
var current_hp : int
var current_action : Action
var current_move : Move
var current_targets : Array[BoardPosition]
var has_acted := false
var incapacitated := false
var initialized := false

# Statuses
var protecting := false
var trapped := false
var trapped_cd := 0
var focusing := false
var focusing_cd := 0
var parrying := false

# Move specific variables
var phys_damage_taken := 0
var mag_damage_taken := 0

var combat_manager : CombatManager


# =================================================================================================


func _ready() -> void:
	if not initialized:
		# Set base stats.
		hp = set_stat(role.hp_rank, true, true)
		current_hp = hp
		atk = set_stat(role.atk_rank, false, true)
		def = set_stat(role.def_rank, false, true)
		mag = set_stat(role.mag_rank, false, true)
		res = set_stat(role.res_rank, false, true)
		spd = set_stat(role.spd_rank, false, true)
		
		# Set growth rates (when I add them)
		hp_growth = set_stat(role.hp_rank, true, false)
		atk_growth = set_stat(role.atk_rank, false, false)
		def_growth = set_stat(role.def_rank, false, false)
		mag_growth = set_stat(role.mag_rank, false, false)
		res_growth = set_stat(role.res_rank, false, false)
		spd_growth = set_stat(role.spd_rank, false, false)
		
		# set random name
		
		print(unit_name + " initialized!")
		initialized = true

# Set "has acted" for incapacitated units at the same time as backline units in case I ever add revives
func take_turn():
	has_acted = true
	
	match current_action:
		Action.MOVE:
			# Play animation
			# Attack all targets simultaneously
			for p in current_targets:
				move_action(p.current_unit, current_move) # I want to clean this up eventually, maybe even attack both targets simultaneously, but for now this works
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
	
	if move.accuracy == 101 or focusing == true:
		accuracy_check = 101
	elif target.parrying == true and move.move_type == Move.Move_Type.PHYSICAL:
		accuracy_check = 0
		debuff_stat(self, Move.Stat.DEFENSE, -1, 2)
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
				print(str(unit_name) + " attacking " + str(target.unit_name) + " with " + str(move.name) + " for " + str(damage_dealt) + "!")
				target.current_hp -= damage_dealt
				if target.current_hp <= 0:
					target.current_hp = 0
					target.incapacitated = true
					target.animated_sprite.play("Death")
				else:
					print(str(target.current_hp) + "/" + str(target.hp) + " left!")
			
			move.Move_Type.MAGIC:
				# Checks if move is healing or offensive magic
				if "Healing" in move.attack_types:
					damage_healed = int((10 + (mag * (1 + (move.power / 100)))) * randf_range(0.9, 1.1))
					if damage_healed < 10:
						damage_healed = 10
					animated_sprite.play("Attack01")
					print(str(unit_name) + " healing " + str(target.unit_name) + " with " + str(move.name) + " for " + str(damage_healed) + "!")
					
					target.current_hp += damage_healed
					if target.current_hp > target.hp:
						current_hp = target.hp
				else:
					if target.protecting == true:
						damage_dealt = 0
					else:
						var weakness = calculate_weakness(target, move)
						damage_dealt = int(((((((2 * ((level + target.level) / 2)) / 5) + 2) * move.power * ((mag * mag_buff) / ((target.res * target.res_buff) + 1))) / 50) + 2) * weakness * randf_range(0.9, 1.1))
						if damage_dealt < 1:
							damage_dealt = 1
					
					animated_sprite.play("Attack01")
					print(str(name) + " attacking " + str(target.name) + " with " + str(move.name) + " for " + str(damage_dealt) + "!")
					target.current_hp -= damage_dealt
					if target.current_hp <= 0:
						target.current_hp = 0
						target.incapacitated = true
						target.animated_sprite.play("Death")
					else:
						print(str(target.current_hp) + "/" + str(target.hp) + " left!")
				
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
		Move.Move_Effect.NONE:
			# No effect.
			pass
		Move.Move_Effect.BUFF:
			buff_stat(target, move.affected_stat, move.stat_stage, move.duration)
		Move.Move_Effect.DEBUFF:
			debuff_stat(target, move.affected_stat, move.stat_stage, move.duration)
		Move.Move_Effect.PROTECT:
			print(str(name) + " is protecting themself!")
			protecting = true
		Move.Move_Effect.REDIRECT:
			# Plays animation ON SELF, not on target
			# Changes foe targeting (on single-target moves, for units who have yet to move) to user's slot
			
			# for each enemy, if target.current_target == PlayerUnit, target.current_target = self
			pass
		Move.Move_Effect.IGNORE:
			# No effects. Check during damage calculations.
			pass
		Move.Move_Effect.PUSH:
			# Moves foe to their backline. REMEMBER TO SET THEIR STUFF TO HAVE ACTED
			pass
		Move.Move_Effect.KNOCK_OFF:
			# Removes held item if they have one
			# Use item logic should double check the item being used, just in case it gets knocked off before use.
			pass
		Move.Move_Effect.DRAIN:
			# Recovers 50% of damage dealt
			pass
		Move.Move_Effect.TRAP:
			target.trapped = true
			target.trapped_cd = 2
		Move.Move_Effect.REMOVE_DEBUFF:
			# Sets all negative stat afflictions to 0 (make sure to reset timers as well)
			if target.atk_buff < 0:
				target.atk_buff = 0
				target.atk_cd = 0	
			if target.def_buff < 0:
				target.def_buff = 0
				target.def_cd = 0
			if target.mag_buff < 0:
				target.mag_buff = 0
				target.mag_cd = 0
			if target.res_buff < 0:
				target.res_buff = 0
				target.res_cd = 0
			if target.spd_buff < 0:
				target.speed_buff = 0
				target.speed_cd = 0
		Move.Move_Effect.REMOVE_ALL:
			target.atk_buff = 0
			target.atk_cd = 0
			target.def_buff = 0
			target.def_cd = 0
			target.mag_buff = 0
			target.mag_cd = 0
			target.res_buff = 0
			target.res_cd = 0
			target.speed_buff = 0
			target.speed_cd = 0
		Move.Move_Effect.SACRIFICE:
			# No effects. Check during move usage.
			pass
		Move.Move_Effect.REVIVE:
			# No effects. Check during move usage.
			pass
		Move.Move_Effect.SPARE:
			# No effects. Check during damage calculations.
			pass
		Move.Move_Effect.SURGE_PROTECTOR:
			target.protecting = true
			if target == self:
				print(str(name) + " is protecting the team!")
				debuff_stat(self, Move.Stat.MAGIC, -1, 2)
		Move.Move_Effect.COUNTER:
			# Deals damage to targeted foe based on "physical damage taken" statistic
			pass
		Move.Move_Effect.COUNTERSPELL:
			# Deals damage to targeted foe based on "magical damage taken" statistic
			pass
		Move.Move_Effect.PARRY:
			target.parrying = true
		Move.Move_Effect.SWAP:
			# Uses swap logic to move to backline
			pass
		Move.Move_Effect.FOCUS:
			target.focusing = true
			target.focusing_cd = 2
		_:
			print("ERROR. Move effect invalid.")
	pass

func item_action():
	pass

func swap_action():
	pass

func buff_stat(target: Unit, stat: Move.Stat, stage: int, duration: int):
	match stat:
		Move.Stat.ATTACK:
			if target.atk_buff < 2:
				target.atk_buff += stage
				clamp(target.atk_buff, -2, 2)
				if target.atk_cd == 0:
					target.atk_cd += duration
			else:
				print(str(target.name) + "'s attack is already at max!")
		Move.Stat.DEFENSE:
			if target.def_buff < 2:
				target.def_buff += stage
				clamp(target.def_buff, -2, 2)
				if target.def_cd == 0:
					target.def_cd += duration
			else:
				print(str(target.name) + "'s defense is already at max!")
		Move.Stat.MAGIC:
			if target.mag_buff < 2:
				target.mag_buff += stage
				clamp(target.mag_buff, -2, 2)
				if target.mag_cd == 0:
					target.mag_cd += duration
			else:
				print(str(target.name) + "'s magic is already at max!")
		Move.Stat.RESISTANCE:
			if target.res_buff < 2:
				target.res_buff += stage
				clamp(target.res_buff, -2, 2)
				if target.res_cd == 0:
					target.res_cd += duration
			else:
				print(str(target.name) + "'s resistance is already at max!")
		Move.Stat.SPEED:
			if target.spd_buff < 2:
				target.spd_buff += stage
				clamp(target.spd_buff, -2, 2)
				if target.spd_cd == 0:
					target.spd_cd += duration
			else:
				print(str(target.name) + "'s speed is already at max!")

func debuff_stat(target: Unit, stat: Move.Stat, stage: int, duration: int):
	match stat:
		Move.Stat.ATTACK:
			if target.atk_buff > -2:
				target.atk_buff += stage
				clamp(target.atk_buff, -2, 2)
				if target.atk_cd == 0:
					target.atk_cd += duration
			else:
				print(str(target.name) + "'s attack is already at minimum!")
		Move.Stat.DEFENSE:
			if target.def_buff > -2:
				target.def_buff += stage
				clamp(target.def_buff, -2, 2)
				if target.def_cd == 0:
					target.def_cd += duration
			else:
				print(str(target.name) + "'s defense is already at minimum!")
		Move.Stat.MAGIC:
			if target.mag_buff > -2:
				target.mag_buff += stage
				clamp(target.mag_buff, -2, 2)
				if target.mag_cd == 0:
					target.mag_cd += duration
			else:
				print(str(target.name) + "'s magic is already at minimum!")
		Move.Stat.RESISTANCE:
			if target.res_buff > -2:
				target.res_buff += stage
				clamp(target.res_buff, -2, 2)
				if target.res_cd == 0:
					target.res_cd += duration
			else:
				print(str(target.name) + "'s resistance is already at minimum!")
		Move.Stat.SPEED:
			if target.spd_buff > -2:
				target.spd_buff += stage
				clamp(target.spd_buff, -2, 2)
				if target.spd_cd == 0:
					target.spd_cd += duration
			else:
				print(str(target.name) + "'s speed is already at minimum!")

func set_stat(rank_to_get: String, is_hp:bool, is_base_stat: bool) -> int:
	# Base stats
	if is_base_stat:
		if is_hp:
			match rank_to_get:
				"S":
					return randi_range(30, 32)
				"A":
					return randi_range(27, 29)
				"B":
					return randi_range(24, 26)
				"C":
					return randi_range(21, 23)
				"D":
					return randi_range(18, 20)
				_:
					print("ERROR. Invalid stat rank.")
					return -1
		else:
			match rank_to_get:
				"S":
					return randi_range(12, 14)
				"A":
					return randi_range(9, 11)
				"B":
					return randi_range(6, 8)
				"C":
					return randi_range(3, 5)
				"D":
					return randi_range(0, 2)
				_:
					print("ERROR. Invalid stat rank.")
					return -1
	# Growth rates
	else:
		if is_hp:
			match rank_to_get:
				"S":
					return randi_range(130, 150) # while the growth rate is above 100, -100 and add a stat to gain, then do rolls
				"A":
					return randi_range(110, 129)
				"B":
					return randi_range(90, 109)
				"C":
					return randi_range(70, 89)
				"D":
					return randi_range(50, 69)
				_:
					print("ERROR. Invalid stat rank.")
					return -1
		else:
			match rank_to_get:
				"S":
					return randi_range(80, 90)
				"A":
					return randi_range(60, 79)
				"B":
					return randi_range(40, 59)
				"C":
					return randi_range(20, 39)
				"D":
					return randi_range(10, 19)
				_:
					print("ERROR. Invalid stat rank.")
					return -1

# Note that I don't actually know if this works fully yet - I just needed the functionality down to mark it off the "in progress" list lol
func increase_stat(growth: int) -> int:
	var stats_to_add := 0
	var growth_bonus := 0
	var counter := 1
	
	# Guarantees a stat point for growths > 100% (literally just HP but I need to have it lol)
	while growth > 100:
			growth -= 100
			growth_bonus += 1
	
	# Adds the stats
	while counter < 3:
		var random = randi_range(0, 100)
		if random <= growth:
			stats_to_add += 1
		stats_to_add += growth_bonus
		
		counter += 1
	
	return stats_to_add

func reset_variables():
	current_move = null
	current_targets.clear()
	has_acted = false
	protecting = false
