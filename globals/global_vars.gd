extends Node

var current_world:String = "real"

var real_inventory_items:Array
var tape_inventory_items:Array

enum RealStates{
	tape1,
	tape2,
	tape3,
	tape4
}

enum TapeStates{
	start,
	lever,
	fuse,
	lamp,
	key
}

var all_real_states := [RealStates.tape1, RealStates.tape2, RealStates.tape3, RealStates.tape4]
var all_tape_states := [TapeStates.start, TapeStates.lever, TapeStates.fuse, TapeStates.lamp]

var real_state_index := 0
var tape_state_index := 0

var real_current_state = all_real_states[real_state_index]
var tape_current_state = all_tape_states[tape_state_index]

var lever_state:String = "off"

var gates_open = [false, false, false, false, false, false, false, false]

var lamps_on = [true, false, false]

var switch_on = [false]


var breaker_state: String = "off"

var player_last_real_pos: Vector3

var player_noise_level: int = 0
var player_light_level: float = 0.0
var light_factor: float = 11.0
