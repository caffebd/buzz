extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func use_action(player):
	GlobalSignals.emit_signal("light_up_crates")
