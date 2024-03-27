extends Camera3D

@onready var player_cam =  %Camera
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform = player_cam.global_transform
