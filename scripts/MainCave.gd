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
		2:
			_check_two()
		3:
			_check_three()
		4:
			_check_four()
		5:
			_check_five()
			

			
	var position = %PlayerCheckPositions.get_child(GlobalVars.check_point)
	player.set_start_position(position.global_position)
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
	%RaisePlatform.remove_key()
	%lever1.lever_set_on()
	%lever2.lever_set_on()
	%lever3.lever_set_on()
	%lever4.lever_set_on()


func _check_four():
	_check_three()
	%key3.queue_free()
	%gate4.needs_key = false
	
func _check_five():
	_check_four()
	
func _on_check_point_1_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 1:
			GlobalVars.check_point = 1


func _on_check_point_2_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 2:
			GlobalVars.check_point = 2


func _on_check_point_3_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 3:
			GlobalVars.check_point = 3


func _on_check_point_4_body_entered(body):
	if body.is_in_group("Player"):
		if GlobalVars.check_point < 4:
			GlobalVars.check_point = 4


func _on_check_point_5_body_entered(body):
	if body.is_in_group("Player") and %"BuzzEnemy5-6".attack_player == false:
		print ("CHECK 5 CHECK 5")
		if GlobalVars.check_point < 5:
			GlobalVars.check_point = 5


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
