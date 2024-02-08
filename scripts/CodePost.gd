extends Node3D

@export var code_select: int

# Called when the node enters the scene tree for the first time.
func _ready():
	var code_boards = %CodeLabels.get_children()
	code_boards[code_select].visible = true

