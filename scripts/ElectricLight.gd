extends Node3D

@export var light_range: float = 7.453
@export var light_energy: float = 0.6

var rng = RandomNumberGenerator.new()

@export var light_state: bool = false
 

#@onready var omni: OmniLight3D = %ElectricOmniLight

# Called when the node enters the scene tree for the first time.
func _ready():
	switch(light_state)
	rng.randomize()
	%ElectricOmniLight.omni_range = light_range
	%ElectricOmniLight.light_energy = light_energy
	


# Called every frame. 'delta' is the elapsed time since the previous frame.



func switch(state):
	light_state = state
	%ElectricOmniLight.visible = light_state
	


func flicker():
	#rng.randf_range(0.2, 0.8)
	var time = 0.25
	for i in 8:
		var yield_timer_a = Timer.new()
		add_child(yield_timer_a)
		yield_timer_a.start(time);
		await yield_timer_a.timeout
		visible = !visible
		yield_timer_a.queue_free()
	%ElectricOmniLight.visible = light_state
