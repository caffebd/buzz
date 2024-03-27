extends Node3D

var ammo_qty: = 10

var ammo_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees.y += 30 * delta


func _on_ammo_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		GlobalSignals.emit_signal("ammo_count", ammo_qty)
		GlobalSignals.emit_signal("respawn_ammo", ammo_count)
		queue_free()
