extends Button
 
enum Button_Type {CONTINUE, CODEX, HOF}

@export var button_type : Button_Type
@export var menu_to_open : Control
@export var menu_to_close : Control


# =================================================================================================


func _ready():
	self.connect("pressed", _on_pressed)
	
	var save_game : SaveData = SafeResourceLoader.load(Global.save_manager.save_game_path) as SaveData
	
	match button_type:
		Button_Type.CONTINUE:
			if save_game.run_ongoing == true:
				disabled = false
		Button_Type.CODEX:
			if save_game.codex_enabled == true:
				disabled = false
		Button_Type.HOF:
			if save_game.hof_enabled == true:
				disabled = false

func _on_pressed():
	menu_to_open.visible = true
	menu_to_close.visible = false
