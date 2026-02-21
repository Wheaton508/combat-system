extends Resource
class_name Role

# enum Weapon_Type {SWORD, LANCE, AXE, BOW, MAGIC, MISC}
# enum Attack_Type {STAB, SLASH, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}

@export_group("Class Data")
@export var name : String
@export var weapon_types : Array[String]
@export var weaknesses : Array[String]

## The unit this class is attached to will inherit these stats as their own on initialization.
@export_group("Base Stats")
var base_hp : int
var base_atk : int
var base_def : int
var base_mag : int
var base_mag_def : int
var base_spd : int

## The unit this class is attached to will inherit these growth rates as their own on initialization.
@export_group("Base Growths")
var base_hp_growth : int
var base_atk_growth : int
var base_def_growth : int
var base_mag_growth : int
var base_mag_def_growth : int
var base_spd_growth : int


# =================================================================================================
