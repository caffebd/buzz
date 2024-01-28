extends ColorRect

@export var noise_level: int

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.noise_level_show.connect(_show_noise_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _show_noise_level(level):
	visible = level >= noise_level
	if level >= 8:
		color = Color("#ffffff")
	elif level > 5:
		color = Color("#ff7d6c")
	else:
		color = Color("#b40000")
