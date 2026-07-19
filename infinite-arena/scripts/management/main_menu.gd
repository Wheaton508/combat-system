class_name MainMenu
extends Node3D

@onready var menu_units: Node = $MenuUnits


# =================================================================================================


func _ready() -> void:
	var save_game : SaveData = SafeResourceLoader.load(Global.save_manager.save_game_path) as SaveData
	
	if save_game.recent_run_roles[0] != null and save_game.recent_run_roles[1] != null and save_game.recent_run_roles[2] != null:
		var menu_units_array : Array[AnimatedSprite3D]
		
		for a in menu_units.get_children():
			if a is AnimatedSprite3D:
				var temp : AnimatedSprite3D = a as AnimatedSprite3D
				menu_units_array.append(temp)
		
		var temp_array : Array[Role] = save_game.recent_run_roles
		temp_array.shuffle()
		
		for i in 3:
			menu_units_array[i].sprite_frames = temp_array[i].ui_sprite
			menu_units_array[i].play("idle")
