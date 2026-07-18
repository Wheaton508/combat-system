class_name Stats
extends Resource

#region ACTUAL STATS
var level : int
var hp : int
var atk : int
var def : int
var mag : int
var res : int
var spd : int
#endregion

#region GROWTH RATES
var hp_growth : int
var atk_growth : int
var def_growth : int
var mag_growth : int
var res_growth : int
var spd_growth : int
#endregion


# =================================================================================================


func _initialize_stats(base_role : Role) -> void:
	level = 1
	
	# Generate base stats
	hp = _set_stat(base_role.hp_rank, true, true)
	atk = _set_stat(base_role.atk_rank, false, true)
	def = _set_stat(base_role.def_rank, false, true)
	mag = _set_stat(base_role.mag_rank, false, true)
	res = _set_stat(base_role.res_rank, false, true)
	spd = _set_stat(base_role.spd_rank, false, true)
	
	# Generate growth rates
	hp_growth = _set_stat(base_role.hp_rank, true, false)
	atk_growth = _set_stat(base_role.atk_rank, false, false)
	def_growth = _set_stat(base_role.def_rank, false, false)
	mag_growth = _set_stat(base_role.mag_rank, false, false)
	res_growth = _set_stat(base_role.res_rank, false, false)
	spd_growth = _set_stat(base_role.spd_rank, false, false)

func _set_stat(rank_to_get : String, is_hp : bool, is_base_stat : bool) -> int:
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
