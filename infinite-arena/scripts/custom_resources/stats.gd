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

func _set_stat() -> void:
	pass
