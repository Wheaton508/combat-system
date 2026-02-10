extends Node3D
class_name Unit

enum Action {ATTACK, ITEM, SWAP}

@export_group("Unit Stats")
@export var hit_points := 0
@export var attack := 0
@export var defense := 0
@export var magic := 0
@export var magic_defense := 0
@export var speed := 0

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
@export var job : Role

@export_group("Node References")
@export var animated_sprite : AnimatedSprite3D

var current_hit_points : int
var effective_max_hp : int
var effective_attack : int
var effective_defense : int
var effective_magic : int
var effective_magic_defense : int
var effective_speed : int

var current_action: Action
var current_move: Move
var current_target: Unit
var has_acted := false
var incapacitated := false


# =================================================================================================


# Set "has acted" for incapacitated units at the same time as backline units in case I ever add revives
func take_turn():
	has_acted = true
	
	match current_action:
		Action.ATTACK:
			attack_action(current_target, current_move)
		Action.ITEM:
			item_action()
		Action.SWAP:
			swap_action()
		_:
			print("ERROR. Ending turn.")

func attack_action(target: Unit, move: Move):
	animated_sprite.play("Attack01")
	print(str(name) + " attacking " + str(target.name) + " with " + str(move.name) + ".")

func item_action():
	pass

func swap_action():
	pass

func update_stats():
	# called whenever a unit levels up or (un)equips an item. likely not using this yet? but nice to have
	pass
