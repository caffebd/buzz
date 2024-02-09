extends CharacterBody3D


var attack_player: bool = false

var start_pos := Vector3.ZERO

@export var player :CharacterBody3D

@export var linked_switch: Node3D

@export var patrolSpeed = 2.5

@export var final_buzz:bool = false

func _ready():
	start_pos = position

func _physics_process(delta):
	if attack_player:
		MoveTowardsPoint(delta, patrolSpeed)
	else:
		var direction = global_position.direction_to(start_pos)
		velocity = direction * patrolSpeed
		move_and_slide()


func MoveTowardsPoint(delta, speed):
	#var targetPos = navigationAgent.get_next_path_position()
	var direction = global_position.direction_to(player.global_position)
	faceDirection(player.position)
	velocity = direction * speed
	move_and_slide()
	

func faceDirection(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)


func _on_death_area_body_entered(body):
	if body.get_groups().has("Player"):
		attack_player = false
		print ("reload")
		GlobalVars.key_count = 0
		if final_buzz:
			call_deferred("game_over_call")
		else:	
			player.hud.cover_fade_death()

func game_over_call():
	get_tree().change_scene_to_file("res://scenes/OverScreen.tscn")

func _on_warn_area_body_entered(body):
	if body.get_groups().has("Player"):
		if linked_switch!=null: linked_switch.flicker()