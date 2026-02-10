extends Resource
class_name Role

enum Weapon_Type {SWORD, LANCE, AXE, BOW, MAGIC, MISC}
enum Attack_Type {STAB, SLASH, CRUSH, FIRE, LIGHTNING, WIND, ICE, DARK, LIGHT, HEALING, NEUTRAL}

@export_group("Class Data")
@export var weapon_types: Array[Weapon_Type]
@export var weaknesses: Array[Attack_Type]


# =================================================================================================
