extends Resource
class_name Role

# enum Weapon_Type {SWORD, LANCE, AXE, BOW, MAGIC, MISC}
# enum Attack_Type {STAB, SLASH, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}

@export_group("Class Data")
@export var name : String
@export var weapon_types : Array[String]
@export var weaknesses : Array[String]

## The unit this class is attached to will get base stats based upon these ranks on initialization.
@export_group("Base Stats")
@export var hp_rank : String
@export var atk_rank : String
@export var def_rank : String
@export var mag_rank : String
@export var mag_def_rank : String
@export var spd_rank : String

# Currently unused. Only needed if I choose to separate base and growth stat ranks, which for now I'm not doing
## The unit this class is attached to will get base stats based upon these ranks on initialization.
#@export_group("Base Growths")
#@export var hp_growth_rank : String
#@export var atk_growth_rank : String
#@export var def_growth_rank : String
#@export var mag_growth_rank : String
#@export var mag_growth_def_rank : String
#@export var spd_growth_rank : String


# =================================================================================================
