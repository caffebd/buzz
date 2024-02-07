extends Node3D


@onready var switch_anim := $SwitchAnim

@export var linked_lights:Array[Node3D]

@export var linked_switches:Array[Node3D]

@export var connected_buzz:CharacterBody3D

@export var switch_on:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func operate_switch():
	if switch_anim.is_playing():
		return
	if !switch_on:
		switch_on = true
		switch_anim.play("on")
		%RedLight.visible = false
		if linked_lights.size() > 0:
			for light in linked_lights:
				light.switch(true)
		if linked_switches.size()>0:
			for switch in linked_switches:
				switch.switch_from_link(true)
		if connected_buzz != null:
			connected_buzz.attack_player = true
	else:
		switch_on = false
		switch_anim.play("off")
		%RedLight.visible = true
		if linked_lights.size() > 0:
			for light in linked_lights:
				light.switch(false)
		if linked_switches.size()>0:
			for switch in linked_switches:
				switch.switch_from_link(false)
		if connected_buzz != null:
			connected_buzz.attack_player = false

func use_action(player):
	operate_switch()


func auto_switch_off():
	switch_on = false
	switch_anim.play("off") 
	if linked_lights.size() > 0:
		for light in linked_lights:
			light.switch(false)


func flicker():
	for lamp in linked_lights:
		lamp.flicker()


func switch_from_link(state):
	print ("I am swithcing from link")
	switch_on = state
	if switch_on:
		switch_anim.play("on")
		%RedLight.visible = false
	else:
		switch_anim.play("off")
		%RedLight.visible = true
