extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.cave_body_off.connect(_body_off)




func _body_off(state):
	%CaveColl.set_deferred("disabled", state)

