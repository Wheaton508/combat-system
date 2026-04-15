extends CanvasLayer
class_name UIManager

@onready var action_select: Menu = $BaseUI/ActionSelect
@onready var move_select: Menu = $BaseUI/MoveSelect
@onready var target_select: Menu = $BaseUI/TargetSelect
@onready var use_item: Menu = $BaseUI/UseItem
@onready var confirm_swap: Menu = $BaseUI/ConfirmSwap
@onready var unit_status: Menu = $BaseUI/UnitStatus
@onready var dialogue_box: DialogueMenu = $BaseUI/DialogueBox

var current_menu : Menu
var menu_history : Array[String]


# =================================================================================================

func _ready() -> void:
	current_menu = action_select

func proceed_menu(menu_to_load : String):
	match menu_to_load:
		"Action Select":
			action_select.visible = true
			current_menu.visible = false
			current_menu = action_select
		"Move Select":
			move_select.visible = true
			current_menu.visible = false
			current_menu = move_select
		"Target Select":
			target_select.visible = true
			current_menu.visible = false
			current_menu = target_select
		"Use Item":
			use_item.visible = true
			current_menu.visible = false
			current_menu = use_item
		"Confirm Swap":
			confirm_swap.visible = true
			current_menu.visible = false
			current_menu = confirm_swap
		"Unit Status":
			# Should do some weird stuff here, just cuz I think it will act slightly differently
			pass
		"Dialogue Box":
			dialogue_box.visible = true
			current_menu.visible = false
			current_menu = dialogue_box
			pass
		_:
			print("ERROR. Invalid UI call.")
	

func previous_menu():
	if current_menu == action_select:
		# Check to see if you can go back
		pass
	else:
		current_menu.previous_menu.visible = true
		current_menu.visible = false
		current_menu = current_menu.previous_menu
