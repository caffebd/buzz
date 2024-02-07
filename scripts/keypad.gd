extends Node3D

var entered_code := ""
var correct_code := "786"

var keypad_locked := false

@export var linked_object: Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	GlobalSignals.key_press.connect( _key_press)

func key_press(key: String):
	if keypad_locked:
		return
	print("You pressed "+str(key))
	if key == "Delete":
		entered_code = ""
		GlobalSignals.emit_signal("keypad_code", entered_code)
		return
	if entered_code.length()<3:
		entered_code = entered_code+key
		GlobalSignals.emit_signal("keypad_code", entered_code)
#		%Code.text = entered_code
		_check_code()
	else:
		entered_code = key
#		%Code.text = entered_code
		GlobalSignals.emit_signal("keypad_code", entered_code)

func _check_code():
	if entered_code == correct_code:
		keypad_locked = true
		print ("DOOR OPEN")
		GlobalSignals.emit_signal("keypad_code", "correct")
		$KeypadArea/keyPadColl.disabled=true
#		GlobalSignals.emit_signal("manual_state_trigger", "patrol", 2)
		GlobalSignals.emit_signal("elevator_open")
#		if linked_object != null:
#			linked_object.linked_action()
