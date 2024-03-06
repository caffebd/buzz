extends Node3D

var entered_code := ""
var correct_code := "6842"
var secret_code := "2535"

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
	%WrongLabel.visible = false
	if key == "clear":
		entered_code = ""
		%CodeLabel.text = ""
		#GlobalSignals.emit_signal("keypad_code", entered_code)
		return
	if key == "enter":
		_check_code()
		return
	if entered_code.length()<4:
		entered_code = entered_code+key
		%CodeLabel.text = entered_code
		#GlobalSignals.emit_signal("keypad_code", entered_code)
#		%Code.text = entered_code
		#_check_code()
	else:
		entered_code = key
		%CodeLabel.text = entered_code
#		%Code.text = entered_code
		#GlobalSignals.emit_signal("keypad_code", entered_code)

func _check_code():
	if entered_code == correct_code:
		keypad_locked = true
		print ("DOOR OPEN")
		%RightLabel.visible = true
		%RightSound.play()
		#GlobalSignals.emit_signal("keypad_code", "correct")
		#$KeypadArea/keyPadColl.disabled=true
#		GlobalSignals.emit_signal("manual_state_trigger", "patrol", 2)
		GlobalSignals.emit_signal("elevator_open")
	elif entered_code == secret_code:
		GlobalVars.secret_area_found = true
		#GlobalSignals.emit_signal("keypad_code", "correct")
		#keypad_locked = true
		GlobalSignals.emit_signal("teleport","up")
	else:
		%WrongSound.play()
		%WrongLabel.visible = true
		
