extends CharacterBody3D

const SNEAK_SPEED: float = 1.0
const WALK_SPEED:float = 2.0
const SPRINT_SPEED:float = 3.0
const JUMP_VELOCITY:float = 4.5
#const SENSITIVITY:float = 0.003
const SENSITIVITY:float = 0.0008

var speed_adjust: float = 0

const BOB_FREQ = 3.0
const BOB_AMP = 0.1
var t_bob = 0.0

var lean_amount = 5
var lean_weight = 0.05

@export var wobble_head:bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var temp_pos:Vector3 = Vector3(18,1,0.198)

var chase_mode := false

var keypad_pause := false

var walk_audio = preload("res://assets/audio/stone_footsteps.mp3")
var run_audio = preload("res://assets/audio/stone_run.mp3")

@onready var head = %Head
@onready var camera = %Camera
@onready var ray = %PlayerRay
@onready var hud = %HUD


var use_cursor: bool = false

var _in_cut_scene: bool = false

var player_added_noise: float = 0.0

@onready var sub_viewport := %SubViewport
@onready var light_detection := %LightDetection
@onready var texture_rect := $TextureRect
@onready var color_rect := $ColorRect
@onready var light_level := $LightLevel

@export var secret_room_pos: Marker3D

var freeze_controls:bool = false
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera.current = false
	use_cursor = false
	sub_viewport.debug_draw = 2
	GlobalSignals.add_to_inventory.connect( _add_to_inventory)
	GlobalSignals.tape_1_set_up.connect(_tape_1_set_up)
	GlobalSignals.tape_2_set_up.connect(_tape_2_set_up)
	GlobalSignals.tape_3_set_up.connect(_tape_3_set_up)
	GlobalSignals.tape_4_set_up.connect(_tape_4_set_up)
	GlobalSignals.lever_set_up.connect(_lever_set_up)
	GlobalSignals.fuse_set_up.connect(_fuse_set_up)
	GlobalSignals.lamp_set_up.connect(_lamp_set_up)
	GlobalSignals.cut_scene.connect(_cut_scene)
	GlobalSignals.teleport.connect(_teleport)
#	Temp chnage player mask to go through cave
	#GlobalSignals.parent_to_elevator.connect(_temp_mask_change)
	
	
	camera.current = true


func _teleport(dir):
	if dir == "up":
		freeze_controls = true
		var yield_timer_teleport = Timer.new()
		add_child(yield_timer_teleport)
		yield_timer_teleport.start(4.0);
		await yield_timer_teleport.timeout
		yield_timer_teleport.queue_free()
		global_position = secret_room_pos.global_position
		freeze_controls = false
		GlobalSignals.emit_signal("secret_area", true)

func set_start_position(start_pos:Vector3):
	global_position = start_pos
	

func _temp_mask_change(new_parent):
	print ("tempo chaneg player mask 1 off")
	set_collision_layer_value(1, false)


func _cut_scene(state):
	_in_cut_scene = state

func _add_to_inventory(item:String):
	if GlobalVars.current_world == "real":
		GlobalVars.real_inventory_items.append(item)
	else:
		GlobalVars.tape_inventory_items.append(item)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if use_cursor:
			return
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60)) 
	if Input.is_action_just_pressed("ui_cancel"):
		if use_cursor:
			use_cursor = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			use_cursor = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("use"):
		_take_action()

func _take_action():
#	if ray == null:
#		return	
	var collider = ray.get_collider()
#	if collider == null:
#		hud.spot_intensity(false)
	if collider != null and collider is StaticBody3D:
		print(collider.name)
		if collider.get_parent().has_method("use_action"):
			collider.get_parent().use_action(self)
		if collider.is_in_group("door"):
			collider.get_parent().get_parent().use_action(self)
		if collider.is_in_group("key"):	
			if keypad_pause:
				return
			keypad_pause = true
#			GlobalSignals.emit_signal("key_press", collider.name)
			collider.get_parent().get_parent().key_press(collider.name)
			var yield_timer_key = Timer.new()
			add_child(yield_timer_key)
			yield_timer_key.start(0.2);
			await yield_timer_key.timeout
			yield_timer_key.queue_free()
			keypad_pause = false
		
		
func _physics_process(delta):
	
	if freeze_controls:
		print ("float")
		velocity.y = JUMP_VELOCITY
		move_and_slide()
		return
		
	if use_cursor or _in_cut_scene:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	

	
	
	var collider = ray.get_collider()
	if collider != null and collider is StaticBody3D:
		if collider.get_parent().has_method("use_action") or collider.is_in_group("key") or collider.is_in_group("door"):
			hud.target.modulate = Color(1,1,1,1)
			#_check_door(collider)
		else:
			hud.target.modulate = Color(1,1,1,0.2)
			#hud.locked.visible = false
			#hud.unlocked.visible = false
	else:
		hud.target.modulate = Color(1,1,1,0.2)
		#hud.locked.visible = false
		#hud.unlocked.visible = false

	if Input.is_action_just_pressed("rotate_cam"):
		_turn_player_b()

	if Input.is_action_just_pressed("rotate_other"):
		_turn_player_a()

	if Input.is_action_just_pressed("test_open"):
		print ("test ele")
		GlobalSignals.emit_signal("elevator_open")

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("run"):
		speed = SPRINT_SPEED
		if $Footsteps.stream != run_audio:
			$Footsteps.stream = run_audio
			$Footsteps.volume_db = -5
	elif Input.is_action_pressed("sneak"):
		speed = SNEAK_SPEED
		if $Footsteps.stream != walk_audio:
			$Footsteps.stream = walk_audio
			$Footsteps.volume_db = -18
	else:
		speed = WALK_SPEED - speed_adjust
		if $Footsteps.stream != walk_audio:
			$Footsteps.stream = walk_audio
			$Footsteps.volume_db = -10
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			#velocity.x = direction.x * speed
			#velocity.z = direction.z * speed
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	


	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2.0)
	#var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	#camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	var move_noise = abs(velocity.z * 3) + abs(velocity.x * 3)
	GlobalVars.player_noise_level = int(move_noise + player_added_noise)
	
	#print (abs(velocity.z) + abs(velocity.x))
	
	if abs(velocity.z) + abs(velocity.x) > 1:
		#print ($Footsteps.playing)
		if not $Footsteps.playing:
		#print ("walking")
			$Footsteps.play()
	else:
		#print ("not walking")
		$Footsteps.stop()
	
	if wobble_head:
		if input_dir.x>0:
			head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(-lean_amount), lean_weight)
		elif input_dir.x<0:
			head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(lean_amount), lean_weight)
		else:
			head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(0), lean_weight)
		
		t_bob += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin =_headbob(t_bob)
		
	move_and_slide()


func _check_door(collider):
	if collider.is_in_group("door"):
		hud.locked.visible = collider.get_parent().get_parent().needs_key
		hud.unlocked.visible = !collider.get_parent().get_parent().needs_key
	else:
		hud.locked.visible = false
		hud.unlocked.visible = false

#func _process(delta):
		## Light detection
	#light_detection.global_position = global_position # Make light detection follow the player
	#var texture = sub_viewport.get_texture() # Get the ViewportTexture from the SubViewport
	#texture_rect.texture = texture # Display this texture on the TextureRect
	#var color = get_average_color(texture) # Get the average color of the ViewportTexture
	#color_rect.color = color # Display the average color on the ColorRect
	#light_level.value = color.get_luminance() # Use the average color's brighness as the light level value
	#light_level.tint_progress.a = color.get_luminance() # Also tint the progress texture with the above
	#GlobalVars.player_light_level = color.get_luminance()
	#print (GlobalVars.player_light_level)


func get_average_color(texture: ViewportTexture) -> Color:
	var image = texture.get_image() # Get the Image of the input texture
	image.resize(1, 1, Image.INTERPOLATE_TRILINEAR) # Resize the image to one pixel
	return image.get_pixel(0, 0) # Read the color of that pixel

func _headbob(time)->Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/ 2) * BOB_AMP
	return pos

func chase_music(playing:bool):
	if playing:
		if !chase_mode:
			chase_mode = true
			$ChaseMusic.play()
#			$ChaseMusicTimer.start()

	else:
		chase_mode = false
#		$ChaseMusicTimer.stop()
		$ChaseMusicFadeOut.play()
		$ChaseMusic.stop()
#		$ChaseMusicFadeIn.stop()
#		$ChaseMusic.stop()

func _on_chase_music_fade_in_finished():
	pass
#	if !$ChaseMusic.playing:
#		$ChaseMusic.play()

func _on_chase_music_timer_timeout():
	if !$ChaseMusic.playing:
		$ChaseMusic.play()



func _tape_1_set_up():
	print ("TAPE 1 SETUP")
#	position = Vector3(-6.74,1,-4.961)
#	position =Vector3(30.2, 1.227, -2.5)
#	position = temp_pos
#	Vector3(30.2, 1.227, -2.5)

func _tape_2_set_up():
	print ("TAPE 2 SETUP")
	position = Vector3(28.9, 1.085, 0.198)
	rotation_degrees = Vector3(0,173,0)

func _tape_3_set_up():
	print ("TAPE 3 SETUP")
#	position = Vector3(-6.74,1,-4.961)
	position = Vector3(28.9, 1.085, 0.198)
	rotation_degrees = Vector3(0,173,0)

func _tape_4_set_up():
	position = Vector3(28.9, 1.085, 0.198)
	rotation_degrees = Vector3(0,173,0)



func _lever_set_up():
	position = Vector3(3.80, 1.227, -19.045)
	camera.current = true

func _fuse_set_up():
	position = Vector3(-6.74,1,-4.961)
	rotation_degrees = Vector3(0,173,0)
	camera.current = true

func _lamp_set_up():
	camera.current = true
	pass


	
func trans_out():
	%HUD.static_transition_out()






func _on_proximity_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	speed_adjust = 1
	print ("near keypad")

func _on_proximity_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	speed_adjust = 0
	print ("far keypad")


func _on_light_timer_timeout():
	light_detection.global_position = global_position # Make light detection follow the player
	var texture = sub_viewport.get_texture() # Get the ViewportTexture from the SubViewport
	texture_rect.texture = texture # Display this texture on the TextureRect
	var color = get_average_color(texture) # Get the average color of the ViewportTexture
	color_rect.color = color # Display the average color on the ColorRect
	light_level.value = color.get_luminance() # Use the average color's brighness as the light level value
	light_level.tint_progress.a = color.get_luminance() # Also tint the progress texture with the above
	GlobalVars.player_light_level = color.get_luminance()
	#print (GlobalVars.player_light_level)


func _turn_player_a():
	var tween = create_tween()
	tween.tween_property(self,"rotation_degrees:y",90, 2)

func _turn_player_b():
	var tween = create_tween()
	tween.tween_property(self,"rotation_degrees:y",180, 2)
