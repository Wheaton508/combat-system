extends Resource
class_name SaveData

#region GENERAL DATA
@export var audio_level : float
@export var sfx_level : float
#endregion

#region RECENT RUN DATA
# units array (probably stores the unit resources? or even just their class data honestly)
#endregion

#region CODEX DATA
@export var codex_enabled : bool
#endregion

#region HALL OF FAME DATA
@export var hof_enabled : bool
@export var stored_runs : Array[HOFData]
#endregion

#region BOOKMARK DATA
@export var run_ongoing : bool
@export var current_turn : int # Make sure this saves the next turn and not the one you just beat lol
# units array
#endregion


# =================================================================================================
