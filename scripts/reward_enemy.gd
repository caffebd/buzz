extends CharacterBody3D


var  speed: float = 2.0
@onready var nav_agent: NavigationAgent3D = %RewardNav
var player: CharacterBody3D

var chase: bool = false

var marker_count: int = 0

var my_home: Marker3D

var current_target

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	var enemy_start_timer = Timer.new()
	add_child(enemy_start_timer)
	enemy_start_timer.start(2.0);
	await enemy_start_timer.timeout
	enemy_start_timer.queue_free()
	chase = true
	visible = true
	current_target = player

	

func _physics_process(delta: float) -> void:
	rotation_degrees.y += 35 * delta
	if not chase:
		return
	nav_agent.set_target_position(current_target.global_position)
	nav_towards_point(delta, speed)
	var distance_to_player:float = global_position.distance_to(player.global_position)	

func nav_towards_point(delta, speed):
	var targetPos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	#faceDirection(current_target.global_position)
	velocity = direction * speed
	move_and_slide()

func faceDirection(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)


func _on_enemy_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$PlayerHit.play()
		GlobalSignals.emit_signal("take_damage")
		current_target = my_home
		var retreat_timer = Timer.new()
		add_child(retreat_timer)
		retreat_timer.start(rng.randf_range(5,15));
		await retreat_timer.timeout
		retreat_timer.queue_free()	
		current_target = player


func _on_enemy_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet"):
		#print ("respawn enemy at "+str(marker_count))
		area.get_parent().queue_free()
		GlobalSignals.emit_signal("respawn_enemy", marker_count, self)
		#queue_free()
