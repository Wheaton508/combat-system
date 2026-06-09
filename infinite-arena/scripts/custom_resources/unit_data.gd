class_name UnitData
extends Resource

@export var unit_name : String
@export var unit_role : Role
@export var unit_stats : Stats = Stats.new() # Initializes a new Stats resource on UnitData creation
@export var move_list : Array[Move]
@export var hat : Equipment
@export var top : Equipment
@export var bottoms : Equipment
@export var weapon : Equipment
@export var accessory : Equipment
@export var item : Item


# =================================================================================================
