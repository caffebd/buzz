extends Node3D


var fallen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fallen = false




func arrow_fall():
	if not fallen:
		fallen = true
		$ArrowDelay.start()


func _on_arrow_delay_timeout() -> void:
	$ArrowFall.play("arrow_fall")
