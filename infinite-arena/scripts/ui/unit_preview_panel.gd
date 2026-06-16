class_name UnitPreviewPanel
extends Control

@onready var unit_name: Label = $NinePatchRect/UnitName
@onready var weapons_list: HBoxContainer = $NinePatchRect/WeaponsList
@onready var weakness_list: HBoxContainer = $NinePatchRect/WeaknessList
@onready var atk_rank_letter: TextureRect = $NinePatchRect/AtkRank/RankLetter
@onready var def_rank_letter: TextureRect = $NinePatchRect/DefRank/RankLetter
@onready var mag_rank_letter: TextureRect = $NinePatchRect/MagRank/RankLetter
@onready var res_rank_letter: TextureRect = $NinePatchRect/ResRank/RankLetter
@onready var hp_rank_letter: TextureRect = $NinePatchRect/HPRank/RankLetter
@onready var spd_rank_letter: TextureRect = $NinePatchRect/SpdRank/RankLetter

var weapon_icons : Array[Node]
var weakness_icons : Array[Node]

var current_role : Role


# =================================================================================================


func _ready() -> void:
	self.connect("visibility_changed", _visibility_changed)
	weapon_icons = weapons_list.get_children()
	weakness_icons = weakness_list.get_children()

func _visibility_changed():
	if visible == true:
		# Update the list of weapons and weaknesses for the given unit
		weapon_icons[0].visible = true
		for w in current_role.weapon_types:
			weapon_icons[w + 1].visible = true
		weakness_icons[0].visible = true
		for w in current_role.weaknesses:
			weakness_icons[w + 1].visible = true
		
		# Update the letter ranks next to each stat to reflect the unit's stats
		unit_name.text = current_role.role_name
		atk_rank_letter.texture = load(_update_rank(current_role.atk_rank))
		def_rank_letter.texture = load(_update_rank(current_role.def_rank))
		mag_rank_letter.texture = load(_update_rank(current_role.mag_rank))
		res_rank_letter.texture = load(_update_rank(current_role.res_rank))
		hp_rank_letter.texture = load(_update_rank(current_role.hp_rank))
		spd_rank_letter.texture = load(_update_rank(current_role.spd_rank))
		
	else:
		for i in weapon_icons:
			i.visible = false
		for i in weakness_icons:
			i.visible = false

func _update_rank(stat_rank_letter : String) -> String:
	var path_to_load : String
	
	match stat_rank_letter:
		"S":
			path_to_load = "res://imports/fantasy_sprites/icons/s_rank.png"
		"A":
			path_to_load = "res://imports/fantasy_sprites/icons/a_rank.png"
		"B":
			path_to_load = "res://imports/fantasy_sprites/icons/b_rank.png"
		"C":
			path_to_load = "res://imports/fantasy_sprites/icons/c_rank.png"
		"D":
			path_to_load = "res://imports/fantasy_sprites/icons/d_rank.png"
		_:
			print_debug("ERROR. Invalid stat rank.")
	
	return path_to_load
