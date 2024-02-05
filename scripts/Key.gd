extends Node3D


# Called when the node enters the scene tree for the first time.
var player: CharacterBody3D


func _ready():
	pass

func use_action(the_player):
	GlobalSignals.emit_signal("update_key", 1)
	queue_free()
