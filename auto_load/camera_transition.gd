extends Node

@onready var camera2D: Camera2D = %Camera2D
@onready var camera3D: Camera3D = %Camera3D
#@onready var tween = get_tree().create_tween()

var transitioning: bool = false

func _ready() -> void:
#	camera2D = %Camera2D
#	camera3D = %Camera3D
	camera3D.current = false
	camera2D.enabled = false
	

func switch_camera(from, to) -> void:
	from.current = false
	to.current = true

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 1.0) -> void:
	if transitioning: return
	var cam_tween = get_tree().create_tween().set_parallel(true)
	
	# Copy the parameters of the first camera
	camera2D.zoom = from.zoom
	camera2D.offset = from.offset
	camera2D.light_mask = from.light_mask
	
	# Move our transition camera to the first camera position
	camera2D.global_transform = from.global_transform
	
	# Make our transition camera current
	camera2D.enabled = true
	
	transitioning = true
	
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	cam_tween.remove_all()
	cam_tween.interpolate_property(camera2D, "global_transform", camera2D.global_transform, 
		to.global_transform, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	cam_tween.interpolate_property(camera2D, "zoom", camera2D.zoom, 
		to.zoom, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	cam_tween.interpolate_property(camera2D, "offset", camera2D.offset, 
		to.offset, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	cam_tween.start()
	
	# Wait for the tween to complete
#	await tween.com
	
	# Make the second camera current
	to.current = true
	transitioning = false
	
func tween_all_done(to):
	to.current = true
	transitioning = false

	

func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: return
	# Copy the parameters of the first camera
	
	var cam_tween = get_tree().create_tween().set_parallel(true)
	
	camera3D.fov = from.fov
	camera3D.cull_mask = from.cull_mask
	
	# Move our transition camera to the first camera position
	camera3D.global_transform = from.global_transform
	
	# Make our transition camera current
	camera3D.current = true
	
	transitioning = true
	
	print ("trans start")
	
	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
#	tween.kill()
	cam_tween.tween_property(camera3D, "global_transform", 
		to.global_transform, duration)
	cam_tween.tween_property(camera3D, "fov", 
		to.fov, duration)
	cam_tween.play()
	
	var callable = Callable(self, "tween_all_done")
	
	# Wait for the tween to complete
	cam_tween.tween_callback(tween_all_done.bind(to)).set_delay(duration+0.2)
#	yield(tween, "tween_all_completed")

	print ("trans done")
	
	# Make the second camera current



