extends Resource
class_name Equipment

#region ENUMS
#enum Equipment_Effects {}
#endregion

#region EQUIPMENT DATA
@export var display_color : Color
@export var id : int
@export var tier : int
#endregion

#region EQUIPMENT DETAILS
@export var sprite : Texture2D
@export var name : String
@export var description : String
#endregion

#region BATTLE DATA
@export var atk_buff : int
@export var def_buff : int
@export var mag_buff : int
@export var res_buff : int
@export var spd_buff : int
@export var elemental_amplifications : Array[Global.Attack_Elements]
@export var elemental_protections : Array[Global.Attack_Elements]
#@export var effects : Array[Equpment_Effects]
#endregion


# =================================================================================================
