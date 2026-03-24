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
@export_subgroup("Effect Details")
@export var affected_stat : Stat
## A flat multiplier applied to unit stats during damange calculations. 1.25/0.75 for +/-1, 1.5/0.5 for +/-2
@export var stat_stage := 0.00
@export var duration := 0

# =================================================================================================

func activate_move_effect():
	match move_effect:
		Move_Effect.NONE:
			pass
		Move_Effect.BUFF:
			pass
		Move_Effect.DEBUFF:
			pass
		Move_Effect.PROTECT:
			pass
		Move_Effect.REDIRECT:
			pass
		Move_Effect.IGNORE:
			pass
		Move_Effect.PUSH:
			pass
		Move_Effect.KNOCK_OFF:
			pass
		Move_Effect.DRAIN:
			pass
		Move_Effect.TRAP:
			pass
		Move_Effect.REMOVE_DEBUFF:
			pass
		Move_Effect.REMOVE_ALL:
			pass
		Move_Effect.SACRIFICE:
			pass
		Move_Effect.REVIVE:
			pass
		Move_Effect.SPARE:
			pass
		Move_Effect.SURGE_PROTECTOR:
			pass
		Move_Effect.COUNTER:
			pass
		Move_Effect.COUNTERSPELL:
			pass
		Move_Effect.PARRY:
			pass
		Move_Effect.SWAP:
			pass
		Move_Effect.FOCUS:
			pass
		_:
			pass
