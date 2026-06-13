class_name UnitPreviewPanel
extends Control

@onready var unit_name: Label = $NinePatchRect/UnitName

var current_role : Role


# =================================================================================================


func _ready() -> void:
	self.connect("visibility_changed", _visibility_changed)

func _visibility_changed():
	if visible == true:
		unit_name.text = current_role.role_name
