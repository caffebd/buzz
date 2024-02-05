extends Node3D

@export var light_range: float = 7.453
@export var light_energy: float = 0.6

#@onready var omni: OmniLight3D = %ElectricOmniLight

# Called when the node enters the scene tree for the first time.
func _ready():
	%ElectricOmniLight.omni_range = light_range
	%ElectricOmniLight.light_energy = light_energy
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func linked_action():
	visible = !visible
