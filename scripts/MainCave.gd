extends Node3D

@onready var player_check_positions: Node3D = %PlayerCheckPositions

@export var player: CharacterBody3D

var rotate_angle: float = 0.0
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
			rotate_angle = deg_to_rad(20.0)
			_check_one()
		2:
			rotate_angle = deg_to_rad(30.0)
			_check_two()
		3:
			rotate_angle = deg_to_rad(140.0)
			_check_three()
		4:
			rotate_angle = deg_to_rad(80.0)
			_check_four()
		5:
			rotate_angle = deg_to_rad(15.0)
			_check_five()
		6:
			rotate_angle = deg_to_rad(175.0)
			_check_six()
		7:
			rotate_angle = deg_to_rad(145.0)
			_check_seven()			
		8:
			rotate_angle = deg_to_rad(100.0)
			_check_eight()
			
	var position = %PlayerCheckPositions.get_child(GlobalVars.check_point)
	player.set_start_position(position.global_position, rotate_angle)
	if GlobalVars.sneaky_wall_open:
		%SneakyLever.lever_set_on()
	if GlobalVars.start_secret_area:
		#player.set_start_position(%SecretAreaPos.global_position)
		player.set_start_position(%KeyPadPos.global_position)

func _check_one():
	%gate.needs_key = false
	%key.queue_free()

func _check_two():
	_check_one()
	%gate2.needs_key = false
	%key2.queue_free()


func _check_three():
	_check_two()
	%gate3.needs_key = false


func _check_four():
	_check_three()
	%key3.queue_free()
	%gate4.needs_key = false

func _check_five():
	_check_four()
	
func _check_six():
	_check_five()
	%gate5.needs_key = false
	%lever2.lever_set_on()
	%lever3.lever_set_on()
	%lever4.lever_set_on()
	%lever5.lever_set_on()
	GlobalSignals.emit_signal("remove_platform_key")

func _check_seven():
	_check_six()
	
func _check_eight():
	_check_seven()

func _player_rotate(dir:float = 0):
	pass
	#player.head.rotation.y = dir
	#print (player.head.rotation.y)

func _on_check_point_1_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 1:
			GlobalVars.check_point = 1
			SaveLoad.save_data()


func _on_check_point_2_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 2:
			GlobalVars.check_point = 2
			SaveLoad.save_data()


func _on_check_point_3_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 3:
			GlobalVars.check_point = 3
			SaveLoad.save_data()


func _on_check_point_4_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 4:
			GlobalVars.check_point = 4
			SaveLoad.save_data()


func _on_check_point_5_body_entered(body):
	if body.is_in_group("Player"):
		print ("CHECK 5 CHECK 5")
		if GlobalVars.check_point < 5:
			GlobalVars.check_point = 5
			SaveLoad.save_data()

func _on_check_point_6_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print ("CHECK 6 ")
		if GlobalVars.check_point < 6:
			GlobalVars.check_point = 6
			SaveLoad.save_data()

func _on_check_point_7_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and %"BuzzEnemy5-6".attack_player == false:
		print ("CHECK 7 ")
		if GlobalVars.check_point < 7:
			GlobalVars.check_point = 7
			SaveLoad.save_data()

func _on_check_point_8_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print ("CHECK 8 ")
		if GlobalVars.check_point < 8:
			GlobalVars.check_point = 8
			SaveLoad.save_data()

func _on_fall_area_body_entered(body):
	if body.is_in_group("Player"):
		%SecretArea.visible = false
		body.global_position = %KeyPadPos.global_position


func _on_platform_death_area_body_entered(body):
		if body.is_in_group("Player"):
			print ("reload")
			GlobalVars.key_count = 0
			player.hud.cover_fade_death()



func _on_secret_room_sensor_body_entered(body):
	GlobalVars.secret_room_found = true
	SaveLoad.save_data()









