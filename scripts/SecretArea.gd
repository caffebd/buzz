extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.secret_area.connect(_activate)


func _activate(state):
	visible = state
