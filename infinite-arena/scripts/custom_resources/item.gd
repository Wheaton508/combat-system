extends Resource
class_name Item

#region ENUMS
#enum Item_Effects {}
#endregion

#region ITEM DATA
@export var display_color : Color
@export var id : int
@export var tier : int
#endregion

#region ITEM DETAILS
@export var sprite : Texture2D
@export var name : String
@export var description : String
#endregion

#region BATTLE DATA
#@export var effect : Item_Effect
#endregion


# =================================================================================================
