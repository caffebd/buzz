extends Node3D

@export var lever_needed:int = 4
var lever_count :int = 0

var bottom_pos: float = -6.0
var top_pos: float = 2.8

# Called when the node enters the scene tree for the first time.



func linked_action():
	lever_count += 1
	if lever_count == lever_needed:
		%WoodenLiftAudio.play()
		var tween = create_tween()
		tween.tween_property(self, "position:y", top_pos, 7)
		%PlatformCode.visible = true
	#if position.y > 2.0:
		#tween.tween_property(self, "position:y", -1.0, 2.0)
	#else:
		#tween.tween_property(self, "position:y", 2.2, 2.0)


func remove_key():
	position.y = top_pos
	%PlatformKey.queue_free()
