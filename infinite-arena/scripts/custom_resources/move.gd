extends Resource
class_name Move

#region ENUMS
enum Damage_Type {PHYSICAL, MAGIC, HEALING, STATUS}
enum Attack_Type {STAB, SLASH, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}
enum Targeting_Type {SINGLE, SPREAD, SELF, ALLY, TEAM, FIELD}
# enum Move_Effect {}
# enum Stat {}
#endregion

#region MOVE DATA
@export var id : int
@export var tier : int
#endregion

#region MOVE DETAILS
@export var name : String
@export var short_name : String
@export var description : String
#endregion

#region BATTLE DATA
@export var power : int
@export var accuracy : int
@export var priority : int
@export var damage_type : Damage_Type
@export var attack_types : Array[Attack_Type]
@export var targeting : Targeting_Type
#endregion


# =================================================================================================
