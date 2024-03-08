extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		call_deferred("_load_main")
		
func _load_main():
	get_tree().change_scene_to_file("res://theCave.tscn")
