extends MeshInstance3D


@export var lever_needed:int = 1
var lever_count :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func linked_action():
	lever_count += 1
	if lever_count == lever_needed:
		var tween = create_tween()
		tween.tween_property(self, "position:y", -4.643, 2.5)
