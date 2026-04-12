extends Resource
class_name Move

enum Move_Type {PHYSICAL, MAGIC, HEALING, STATUS}
# enum Weapon_Type {SWORD, LANCE, AXE, BOW, MAGIC, MISC}
# enum Attack_Type {STAB, SLASH, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}
enum Targeting_Type {SINGLE, SPREAD, SELF, ALLY, TEAM, FIELD}
enum Move_Effect {NONE, BUFF, DEBUFF, PROTECT, REDIRECT, IGNORE, PUSH, KNOCK_OFF, DRAIN, TRAP, REMOVE_DEBUFF, REMOVE_ALL, SACRIFICE, REVIVE, SPARE, SURGE_PROTECTOR, COUNTER, COUNTERSPELL, PARRY, SWAP, FOCUS}
enum Stat {NONE, ATTACK, DEFENSE, MAGIC, RESISTANCE, SPEED}

@export_group("Move Details")
@export var name : String
## Maximum of eight characters (I think)
@export var short_name : String
@export var description : String
@export var tier := 1

@export_group("Move Stats")
@export var power := 0
@export var accuracy := 0
@export var priority := 0
@export var move_type: Move_Type
@export var weapon_types: Array[String]
@export var attack_types: Array[String]
@export var targeting_type : Targeting_Type
@export var move_effect : Move_Effect
@export var fails_in_succession : bool
#@export_subgroup("Effect Details")
@export var affected_stat : Stat
## A flat multiplier applied to unit stats during damange calculations. 1.25/0.75 for +/-1, 1.5/0.5 for +/-2
# Eventually just make this a flat -2 to 2, and handle the exact percentages in the buff functions
@export var stat_stage := 0
@export var duration := 0

# =================================================================================================
