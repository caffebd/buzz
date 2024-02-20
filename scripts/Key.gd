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
	%keyCollect.play()
	GlobalSignals.emit_signal("update_key", 1)
	visible= false
	var key_timer = Timer.new()
	add_child(key_timer)
	key_timer.start(0.8);
	await key_timer.timeout
	print ("key timer out")
	key_timer.queue_free()
	queue_free()


	
	
