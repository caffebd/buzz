extends Node3D

@export var lever_needed:int = 1
var lever_count :int = 0

# Called when the node enters the scene tree for the first time.



func linked_action():
	lever_count += 1
	if lever_count == lever_needed:
		var tween = create_tween()
		tween.tween_property(self, "position:y", -3.5, 2.5)
	#if position.y > 2.0:
		#tween.tween_property(self, "position:y", -1.0, 2.0)
	#else:
		#tween.tween_property(self, "position:y", 2.2, 2.0)


func remove_key():
	position.y = -3.5
	%PlatformKey.queue_free()
