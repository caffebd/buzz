extends Node3D

var enemy_scene = preload("res://scenes/reward_enemy.tscn")
var ammo_scene = preload("res://scenes/ammo_box.tscn")

var enemy_speed_multiplier: float = 1.0

var ammo_left: int = 20

var play_time: int = -1 

var rng = RandomNumberGenerator.new()

var immunity: bool = false

@export var player: CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	GlobalSignals.respawn_enemy.connect(_respawn_enemy)
	GlobalSignals.take_damage.connect(_take_damage)
	GlobalSignals.ammo_count.connect(_ammo_count)
	GlobalSignals.respawn_ammo.connect(_respawn_ammo)
	GlobalSignals.reward_over.connect(_over_pop_up)
	%Rewardpop.visible = false
	%Ammo.text = str(ammo_left)
	%TimeLabel.text = str(play_time)
	_all_enemies()
	_all_ammo()

func _take_damage():
	if not immunity:
		immunity = true
		%HealthBar.value -= 4
		if %HealthBar.value  <= 0:
			print ("GAME OVER")
			GlobalSignals.emit_signal("reward_over")
		var immunity_timer = Timer.new()
		add_child(immunity_timer)
		immunity_timer.start(0.25);
		await immunity_timer.timeout
		immunity_timer.queue_free()
		immunity = false	


func _over_pop_up():
	$PlayTimer.stop()
	_destroy_all_enemies()
	%YourTime.text = str(play_time) + " seconds"
	if play_time > GlobalVars.reward_time:
		%NewBestTime.play()
		GlobalVars.reward_time = play_time
		SaveLoad.save_data()
	else:
		$GameOver.play()
	%BestTime.text = str(GlobalVars.reward_time) + " seconds"
	%Rewardpop.visible = true

func _ammo_count(amount):
	if amount > 0:
		$CollectAmmo.play()
		for i in amount:
			ammo_left += 1
			%Ammo.text = str(ammo_left)
			var ammo_collect_timer = Timer.new()
			add_child(ammo_collect_timer)
			ammo_collect_timer.start(0.1);
			await ammo_collect_timer.timeout
			ammo_collect_timer.queue_free()
	else:
		ammo_left += amount
		%Ammo.text = str(ammo_left)	
	
func _all_enemies():
	var marker_count = %EnemyPositions.get_child_count()
	for mark in marker_count:
		var enemy: CharacterBody3D = enemy_scene.instantiate()
		%Enemies.add_child(enemy)
		enemy.marker_count = mark
		enemy.player = player
		enemy.my_home = %EnemyPositions.get_child(mark)
		enemy.global_position = %EnemyPositions.get_child(mark).global_position


func _respawn_enemy(marker_count):
	$EnemyHit.play()
	var enemy: CharacterBody3D = enemy_scene.instantiate()
	%Enemies.add_child(enemy)
	enemy.marker_count = marker_count
	enemy.player = player
	enemy.speed = enemy_speed_multiplier
	enemy.my_home = %EnemyPositions.get_child(marker_count)
	enemy.global_position = %EnemyPositions.get_child(marker_count).global_position
		
func _all_ammo():
	var ammo_count = %AmmoSpawn.get_child_count()
	for mark in ammo_count:
		var ammo_box: Node3D = ammo_scene.instantiate()
		%AmmoBoxes.add_child(ammo_box)
		ammo_box.ammo_count = mark
		ammo_box.global_position = %AmmoSpawn.get_child(mark).global_position


func _respawn_ammo(marker_count):
	var using_marker:Marker3D =  %AmmoSpawn.get_child(marker_count)
	var ammo_timer = Timer.new()
	add_child(ammo_timer)
	ammo_timer.start(rng.randf_range(20,60));
	await ammo_timer.timeout
	ammo_timer.queue_free()	
	var distance_to_player:float = player.global_position.distance_to(using_marker.global_position)	
	#print (distance_to_player)
	if distance_to_player > 8.0:
		var ammo_box: Node3D = ammo_scene.instantiate()
		%AmmoBoxes.add_child(ammo_box)
		ammo_box.ammo_count = marker_count
		ammo_box.global_position = using_marker.global_position
	else:
		#print ("Too close")
		_respawn_ammo(marker_count)

func _on_enemy_speed_timer_timeout() -> void:
	enemy_speed_multiplier *= 1.2
	if enemy_speed_multiplier >= 4:
		enemy_speed_multiplier = 4
		$EnemySpeedTimer.stop()


func _on_play_timer_timeout() -> void:
	play_time += 1
	%TimeLabel.text = str(play_time)


func _destroy_all_enemies():
	for enemy in %Enemies.get_children():
		enemy.queue_free()
		$EnemySpeedTimer.stop()

func _on_play_reward_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
