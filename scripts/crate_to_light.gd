extends Node3D


@export var light_on: bool = false
@export var can_light: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.light_up_crates.connect(_light_on)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _light_on():
	if can_light:
		%CrateLight.visible = true


func use_action(player):
	GlobalSignals.emit_signal("light_up_crates")
