extends Node3D


@export var lever_needed:int = 1
var lever_count :int = 0

# Called when the node enters the scene tree for the first time.

func _ready():
	GlobalSignals.elevator_open.connect(linked_action)
	if GlobalVars.sneaky_wall_open:
		_open_sneaky_wall()
	else:
		position.z = 23.389

func linked_action():
	lever_count += 1
	if lever_count == lever_needed:
		var tween = create_tween()
		tween.tween_property(self, "position:z", 22.0, 3.0)
	#if position.y > 2.0:
		#tween.tween_property(self, "position:y", -1.0, 2.0)
	#else:
		#tween.tween_property(self, "position:y", 2.2, 2.0)


func _open_sneaky_wall():
	position.z = 23.389
