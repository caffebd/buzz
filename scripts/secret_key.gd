extends Node3D


# Called when the node enters the scene tree for the first time.
var player: CharacterBody3D

var picked: bool = false

@export var is_visible: bool = true
@export var switch_effected: bool = true


func _ready():
	GlobalSignals.key_show.connect(_key_show)
	visible = is_visible
	%KeyCol.disabled = !is_visible



func _key_show(state):
	if switch_effected:
		visible = state
		%KeyCol.disabled = !state
	
func use_action(the_player):
	if picked:
		return
	picked = true
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



	
	
