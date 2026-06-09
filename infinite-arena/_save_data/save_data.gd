class_name SaveData
extends Resource

#region GENERAL DATA
@export var music_level : float
@export var sfx_level : float
#endregion

#region RECENT RUN DATA
@export var recent_run_roles : Array[Role]
#endregion

#region CODEX DATA
@export var codex_enabled : bool
# All dictionaries use the item's ID number for the key value
@export var roles_dict : Dictionary[int, bool]
@export var moves_dict : Dictionary[int, bool]
@export var equipment_dict : Dictionary[int, bool]
@export var item_dict : Dictionary[int, bool]
#endregion

#region HALL OF FAME DATA
@export var hof_enabled : bool
@export var stored_runs : Array[HOFData]
#endregion

#region BOOKMARK DATA
@export var run_ongoing : bool
@export var current_turn : int  # Saves the turn you are going into, not the one you just beat
@export var current_units_dict : Dictionary[String, UnitData] # Utilizes "Primary", "Secondary", and "Backline" as keys to more efficiently save board position
#endregion


# =================================================================================================
