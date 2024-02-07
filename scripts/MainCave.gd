extends Node3D

@onready var player_check_positions: Node3D = %PlayerCheckPositions

@export var player: CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_from_check()
	
	#GlobalSignals.check_one.connect(_check_one)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _setup_from_check():
	match GlobalVars.check_point:
		1:
			_check_one()
	var position = %PlayerCheckPositions.get_child(GlobalVars.check_point)
	player.set_start_position(position.global_position)

func _check_one():
	%gate.needs_key = false
	%key.queue_free()




func _on_check_point_1_body_entered(body):
	if GlobalVars.check_point < 1:
		GlobalVars.check_point = 1
