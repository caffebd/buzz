extends Node3D


@export var gate_no: int

@export var needs_key: bool

@export var locked_no_key: bool

var can_bake: bool = false

func _ready():
	if GlobalVars.gates_open[gate_no] == false:
		%GateAnim.play("already_closed")
	else:
		%GateAnim.play("already_open")
	#$Centre/DoorCol.disabled = GlobalVars.gates_open[gate_no]

# Called when the node enters the scene tree for the first time.
func linked_action():
	print("open the gate")
	if %GateAnim.is_playing():
		return
	if GlobalVars.gates_open[gate_no] == false:
		%GateAnim.play("gate_open")
		GlobalVars.gates_open[gate_no] = true
		needs_key = false
	else:
		%GateAnim.play("gate_close")
		GlobalVars.gates_open[gate_no] = false
	
	print (GlobalVars.gates_open[gate_no])
	
	#$Centre/DoorCol.disabled = GlobalVars.gates_open[gate_no]

func use_action(the_player):
	if locked_no_key:
		return
	var hud = the_player.hud
	if needs_key:
		if GlobalVars.key_count > 0:
			needs_key = false
			linked_action()

			hud._update_key(-1)
	else:
		linked_action()


func _on_gate_anim_animation_finished(anim_name):
	if !can_bake:
		can_bake = true
		return
	#if anim_name == "open_gate":
		#if GlobalVars.tape_current_state == GlobalVars.TapeStates.lever:
			#GlobalVars.real_state_index += 1
			#GlobalVars.real_current_state = GlobalVars.all_real_states[GlobalVars.real_state_index]
			#GlobalVars.current_world = "real"
			#GlobalSignals.emit_signal("change_scene", "real")
	GlobalSignals.emit_signal("bake_nav")
