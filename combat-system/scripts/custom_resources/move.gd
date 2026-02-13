extends Resource
class_name Move

enum Move_Type {PHYSICAL, MAGIC, STATUS}
# enum Weapon_Type {SWORD, LANCE, AXE, BOW, MAGIC, MISC}
# enum Attack_Type {STAB, SLASH, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}
enum Targeting_Type {SINGLE, SPREAD, SELF, ALLY, TEAM, FIELD}
enum Move_Effect {NONE, BUFF, DEBUFF, PROTECT, REDIRECT}

@export_group("Move Details")
@export var name : String
## Maximum of eight characters (I think)
@export var short_name : String
@export var description : String

@export_group("Move Stats")
@export var power := 0
@export var accuracy := 0
@export var move_type: Move_Type
@export var weapon_types: Array[String]
@export var attack_types: Array[String]
@export var targeting_type : Targeting_Type
@export var move_effect : Move_Effect


# =================================================================================================
