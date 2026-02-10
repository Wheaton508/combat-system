extends Resource
class_name Stats

@export_group("Unit Stats")
@export var hit_points := 0
@export var attack := 0
@export var defense := 0
@export var magic := 0
@export var magic_defense := 0
@export var speed := 0

@export_group("Equipment")
@export var hat : Equipment
@export var top : Equipment
@export var bottoms : Equipment
@export var equipment_one : Equipment
@export var equipment_two : Equipment
@export var item : Item

@export_group("Moves")
@export var moves : Array[Move] = [null, null, null, null]


# =================================================================================================
