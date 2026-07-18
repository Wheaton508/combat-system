class_name Equipment
extends Resource

#region ENUMS
enum Equipment_Type {HAT, TOP, BOTTOM, WEAPON, ACCESSORY}
#enum Equipment_Effects {}
#endregion

#region EQUIPMENT DATA
@export var display_color : Color
@export var id : int
@export var tier : int
@export var equip_type : Equipment_Type
#endregion

#region EQUIPMENT DETAILS
@export var sprite : Texture2D
@export var name : String
@export var description : String
#endregion

#region BATTLE DATA
# These stats can go below zero, but are clamped during damage calculations and on UI interfaces
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
