class_name SaveManager
extends Node

const save_game_path = "user://savegame.tres"


# =================================================================================================


func _ready() -> void:
	Global.save_manager = self
	
	if ResourceLoader.exists(save_game_path):
		load_save_file()
	else:
		initialize_save_file()

# Called the first time the game is booted up, and when the save file is deleted
func initialize_save_file() -> void:
	var save_game : SaveData = SaveData.new()
	
	# Initialize save data stats
	save_game.music_level = 1.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(1.0))
	save_game.sfx_level = 1.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(1.0))
	
	save_game.recent_run_roles = [null, null, null]
	
	save_game.codex_enabled = false
	
	for n in 20:
		save_game.roles_dict[n] = false
	for n in 153:
		save_game.moves_dict[n] = false
	for n in 112:
		save_game.equipment_dict[n] = false
	for n in 21:
		save_game.item_dict[n] = false
	
	save_game.hof_enabled = false
	save_game.stored_runs = [null, null, null, null, null]
	
	save_game.run_ongoing = false
	save_game.current_turn = 0
	save_game.current_units_dict = {"Primary" : null, "Secondary" : null, "Backline" : null}

	ResourceSaver.save(save_game, save_game_path)

func load_save_file() -> void:
	print("loading yo shii rn!")
	var save_game : SaveData = SafeResourceLoader.load(save_game_path) as SaveData
	# set relavant info such as:
		# bookmark data
		# main menu units
	pass
