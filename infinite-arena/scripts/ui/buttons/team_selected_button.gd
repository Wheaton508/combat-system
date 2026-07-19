extends Button

@export var scene_path_to_load : String


# =================================================================================================


func _ready():
	self.connect("pressed", _on_pressed)

func _on_pressed():
	var save_game : SaveData = SafeResourceLoader.load(Global.save_manager.save_game_path) as SaveData
	
	save_game.recent_run_roles[0] = Global.units_dict["Primary"].unit_role
	save_game.recent_run_roles[1] = Global.units_dict["Secondary"].unit_role
	save_game.recent_run_roles[2] = Global.units_dict["Backline"].unit_role
	
	ResourceSaver.save(save_game, Global.save_manager.save_game_path)
	
	Global.scene_manager._load_scene(scene_path_to_load)
