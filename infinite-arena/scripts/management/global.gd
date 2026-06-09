extends Node

#region GLOBAL ENUMS
enum Attack_Elements {SLASH, STAB, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}
#endregion

#region NODE REFERENCES
var scene_manager : SceneManager
var save_manager : SaveManager
#endregion

#region GAMEPLAY VARIABLES
var units_dict : Dictionary[String, UnitData] = {
	"Primary" : null,
	"Secondary" : null,
	"Backline" : null
}
#endregion


# =================================================================================================
