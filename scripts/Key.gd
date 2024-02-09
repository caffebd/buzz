extends Node3D


# Called when the node enters the scene tree for the first time.
var player: CharacterBody3D

var picked: bool = false

func _ready():
	pass

func use_action(the_player):
	if picked:
		return
	picked = true
	print ("grab key")
	GlobalSignals.emit_signal("update_key", 1)
	queue_free()
