extends MeshInstance3D

@export var needs_key: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func use_action(the_player):
	print("open the gate")
	var hud = the_player.hud
	if needs_key:
		if GlobalVars.key_count > 0:
			%GateOpen.play()
			var tween = create_tween()
			tween.tween_property(self, "position:y", 4.2, 2.0)
			hud._update_key(-1)
			needs_key = false
			await  tween.finished
			visible = false
		else:
			print ("locked")
			hud.display_locked()
			%GateLocked.play()
