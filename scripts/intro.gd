extends Node3D

var barrier_follow: bool = false
@export var player: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Barrier.global_position.y = 20.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if barrier_follow:
		%Barrier.global_position.z = player.global_position.z + 1.0


func _on_end_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		call_deferred("_load_main")
		
func _load_main():
	get_tree().change_scene_to_file("res://theCave.tscn")


func _on_barrier_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		%Barrier.global_position.y = 1.0
		#barrier_follow = true
	
