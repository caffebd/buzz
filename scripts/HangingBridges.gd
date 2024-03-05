extends Node3D

@export var lever_needed:int = 1
var lever_count :int = 0

var bottom_pos: float = 0.5
var top_pos: float = 19.0

# Called when the node enters the scene tree for the first time.



func linked_action():
	lever_count += 1
	if lever_count == lever_needed:
		%BridgeAudio.play()
		var tween = create_tween()
		tween.tween_property(self, "position:y", bottom_pos, 7)




