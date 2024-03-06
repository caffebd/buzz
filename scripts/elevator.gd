extends Node3D

var door_was_closed := true

var move_up: bool = false

@export var call_buzz: CharacterBody3D
@export var connected_buzz: CharacterBody3D

var elevator_speed: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.elevator_open.connect(_door_open_trigger)
	GlobalSignals.elevator_close.connect(_door_close_trigger)
	#_door_close_trigger()
	#var yield_timer_a = Timer.new()
	#add_child(yield_timer_a)
	#yield_timer_a.start(6);
	#await yield_timer_a.timeout
	#move_up = true
	#_door_open_trigger()
	#var yield_timer_b = Timer.new()
	#add_child(yield_timer_b)
	#yield_timer_b.start(8);
	#await yield_timer_b.timeout
	#_door_close_trigger()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if move_up:
		%Plane_037.global_position.y += elevator_speed * delta
		%Plane_044.global_position.y += elevator_speed * delta
		%Cube_068.global_position.y += elevator_speed * delta
		
func _door_open_trigger():
	print("ele open")
	%AnimationPlayer.play("Key_003Action_002")
	call_deferred("door_col_state")
	door_was_closed = false
	
func _door_close_trigger():
	print("ele close")
	%AnimationPlayer.play_backwards("Key_003Action_002")
	call_deferred("door_col_state")


func door_col_state():
	%DoorCol.disabled = !%DoorCol.disabled

func _on_inside_trigger_body_entered(body):
	if body.is_in_group("Player") and not door_was_closed:
		door_was_closed = true
		connected_buzz.attack_player = false
		#GlobalSignals.emit_signal("cave_body_off", true)
		GlobalSignals.emit_signal("elevator_close")
		GlobalSignals.emit_signal("parent_to_elevator" )
		#GlobalSignals.emit_signal("manual_state_trigger", "patrol", 2)
		var yield_timer_a = Timer.new()
		add_child(yield_timer_a)
		yield_timer_a.start(3);
		await yield_timer_a.timeout
		move_up = true
		call_buzz.attack_player = true
		var yield_timer_b = Timer.new()
		add_child(yield_timer_b)
		yield_timer_b.start(4);
		await yield_timer_a.timeout
		_flicker_light()

func _flicker_light():
	var rng = RandomNumberGenerator.new()
	for i in 40:
		%elecLight.visible = !%elecLight.visible
		var yield_timer_r = Timer.new()
		add_child(yield_timer_r)
		yield_timer_r.start(rng.randf_range(0.1, 0.2));
		await yield_timer_r.timeout
	%elecLight.visible = false
		


func _on_end_trigger_body_entered(body):
	print (body)
	if body.is_in_group("Player"):
		print ("YEP PLAY HERE")
		_flicker_light()
		GlobalSignals.emit_signal("end_game")
