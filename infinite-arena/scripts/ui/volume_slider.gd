extends HSlider

enum Slider_Type {MUSIC, SFX}

@export var slider_type : Slider_Type

var bus_index

# =================================================================================================

func _ready() -> void:
	self.connect("visibility_changed", _visibility_changed)
	self.connect("drag_ended", _drag_ended)
	
	match slider_type:
		Slider_Type.MUSIC:
			bus_index = AudioServer.get_bus_index("Music")
		Slider_Type.SFX:
			bus_index = AudioServer.get_bus_index("SFX")

func _visibility_changed() -> void:
	if visible == true:
		var save_game : SaveData = SafeResourceLoader.load(Global.save_manager.save_game_path) as SaveData
		
		match slider_type:
			Slider_Type.MUSIC:
				value = save_game.music_level
			Slider_Type.SFX:
				value = save_game.sfx_level

func _drag_ended(value_change : bool):
	if value_change:
		var save_game : SaveData = SafeResourceLoader.load(Global.save_manager.save_game_path) as SaveData
		
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
		match slider_type:
			Slider_Type.MUSIC:
				save_game.music_level = value
				ResourceSaver.save(save_game, Global.save_manager.save_game_path)
			Slider_Type.SFX:
				save_game.sfx_level = value
				ResourceSaver.save(save_game, Global.save_manager.save_game_path)
	
	# if slider_type == Slider_Type.SFX:
		# play test sfx
