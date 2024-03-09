extends Node3D

@export var light_range: float = 7.453
@export var light_energy: float = 0.6

@export var disabled: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if disabled:
		visible = false
	%LanternLight.omni_range = light_range
	%LanternLight.light_energy = light_energy


func _on_playert_detect_area_area_entered(area):
	pass
	#if not disabled:
		#print ("VISIBLE Light")
		#visible = true
	
	


func _on_playert_detect_area_area_exited(area):
	pass
	#if not disabled:
		#print ("NO VISIBLE Light")
		#visible = false
