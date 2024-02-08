extends MeshInstance3D


@export var lever_needed:int = 1
var lever_count :int = 0

# Called when the node enters the scene tree for the first time.

func _ready():
	if GlobalVars.sneaky_wall_open:
		_open_sneaky_wall()
		

func linked_action():
	lever_count += 1
	if lever_count == lever_needed:
		var tween = create_tween()
		tween.tween_property(self, "position:y", 8.0, 2.5)
	#if position.y > 2.0:
		#tween.tween_property(self, "position:y", -1.0, 2.0)
	#else:
		#tween.tween_property(self, "position:y", 2.2, 2.0)


func _open_sneaky_wall():
	position.y = 8.0
