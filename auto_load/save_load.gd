extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "buzz_save.json"
const SECURITY_KEY = "25qjd842eif362"

func _ready():
	_verify_save_dir(SAVE_DIR)

func _verify_save_dir(path:String):
	DirAccess.make_dir_absolute(path)

func save_data():
	var file = FileAccess.open(SAVE_DIR+SAVE_FILE_NAME, FileAccess.WRITE)
	#var file = FileAccess.open_encrypted_with_pass(SAVE_DIR+SAVE_FILE_NAME, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print (FileAccess.get_open_error())
		return
	var data = {
		"the_buzz_data":{
		"difficulty_level": GlobalVars.difficulty_level,
		"check_point": GlobalVars.check_point,
		"secret_room_found":GlobalVars.secret_room_found,
		"secret_area_found" : GlobalVars.secret_area_found,
		"sneaky_wall_open": GlobalVars.sneaky_wall_open,

		}
	}
	
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_DIR+SAVE_FILE_NAME):
		var file = FileAccess.open(SAVE_DIR+SAVE_FILE_NAME, FileAccess.READ)
		#var file = FileAccess.open_encrypted_with_pass(SAVE_DIR+SAVE_FILE_NAME, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print (FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data ==  null:
			printerr("cannot parse data")
			return
		
		var buzzData = data["the_buzz_data"]
		
		GlobalVars.difficulty_level = buzzData["difficulty_level"]
		GlobalVars.check_point = buzzData["check_point"]
		GlobalVars.secret_room_found = buzzData["secret_room_found"]
		GlobalVars.secret_area_found = buzzData["secret_area_found"]
		GlobalVars.sneaky_wall_open = buzzData["sneaky_wall_open"]

	
	
	else:
		printerr("cannot open file at %s" % [SAVE_DIR+SAVE_FILE_NAME])



	

