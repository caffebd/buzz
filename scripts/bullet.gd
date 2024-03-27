extends Node3D

const SPEED: float = 40.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0,-SPEED) * delta


func _on_bullet_area_body_entered(body: Node3D) -> void:
	if not body.is_in_group("enemy"):
		print ("Bully hit")
		queue_free()
