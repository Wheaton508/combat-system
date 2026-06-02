class_name Move
extends Resource

#region ENUMS
enum Damage_Type {PHYSICAL, MAGIC, HEALING, STATUS}
enum Targeting_Type {SINGLE, SPREAD, SELF, ALLY, TEAM, FIELD}
# enum Move_Effect {}
# enum Stat {}
#endregion

#region MOVE DATA
@export var display_color : Color
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
@export var attack_elements : Array[Global.Attack_Elements]
@export var targeting : Targeting_Type
#endregion


# =================================================================================================
