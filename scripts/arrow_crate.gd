extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func use_action(player):
	var tween = create_tween()
	tween.tween_property(%arrow, "position:y", -0.07, 1.75)
