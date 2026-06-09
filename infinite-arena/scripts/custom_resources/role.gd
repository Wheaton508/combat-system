class_name Role
extends Resource

#region CLASS DATA
@export var role_name : String
@export var weaknesses : Array[Global.Attack_Elements]
@export var unit_node_to_load : String # A file path to the unit node corresponding to the role
@export var ui_sprite : SpriteFrames # Used for things like the codex, hall of fame, and main menu
#endregion

#region STAT RANKS
@export var hp_rank : String
@export var atk_rank : String
@export var def_rank : String
@export var mag_rank : String
@export var res_rank : String
@export var spd_rank : String
#endregion

#region BASE KIT DATA
@export var starting_equipment : Array[Equipment]
#endregion

#region LEARNSET DATA

#endregion


# =================================================================================================
