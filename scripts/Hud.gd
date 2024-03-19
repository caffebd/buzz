extends Control

@onready var inventory_grid = %InventoryGrid

signal can_load_now()

signal screen_is_hidden()

var tape_icon
var fuse_icon
var lantern_icon
var key_icon



@onready var target := %Target
@onready var locked := %Locked
@onready var unlocked := %Unlocked

# Called when the node enters the scene tree for the first time.
func _ready():
	%KeyGrid.visible = GlobalVars.key_count > 0
	%KeyCount.text = str(GlobalVars.key_count)
	GlobalSignals.add_to_inventory.connect(add_to_carried_inventory)
	GlobalSignals.remove_from_inventory.connect(remove_from_carried_inventory)
	GlobalSignals.keypad_code.connect(_update_keypad_code)
	GlobalSignals.update_key.connect(_update_key)
	GlobalSignals.hud_menu_cover.connect(_menu_cover_enter)
	if GlobalVars.current_world=="tape":
		$PlayLabel.visible = true
	%Target.modulate = Color(1,1,1,0.2)

func _process(delta):
	var adjusted_light = GlobalVars.player_light_level*GlobalVars.light_factor
	%NoiseLevel.text = "Light: "+str(int(adjusted_light))
	GlobalSignals.emit_signal("noise_level_show", int(adjusted_light))
		
		
	

func _update_keypad_code(code):
	if code == "correct":
		var yield_timer_key_correct = Timer.new()
		add_child(yield_timer_key_correct)
		yield_timer_key_correct.start(1);
		await yield_timer_key_correct.timeout
		$CodeRect.visible = false
		return
	$CodeRect.visible = true
	$CodeRect/CodeText.text = code
	
func _update_key(count:int):
	GlobalVars.key_count += count
	print ("keys "+str(GlobalVars.key_count))
	%KeyGrid.visible = GlobalVars.key_count > 0
	%KeyCount.text = str(GlobalVars.key_count)

	

func add_to_carried_inventory(item:String):
	match item:
		#"tape":
			#tape_icon = preload("res://scenes/tape_icon.tscn").instantiate()
			#tape_icon.name = item
			#inventory_grid.add_child(tape_icon)
		#"fuse":
			#fuse_icon = preload("res://scenes/fuse_icon.tscn").instantiate()
			#fuse_icon.name = item
			#inventory_grid.add_child(fuse_icon)
		#"lantern":
			#lantern_icon = preload("res://scenes/lantern_icon.tscn").instantiate()
			#lantern_icon.name = item
			#inventory_grid.add_child(lantern_icon)
		"key":
			key_icon = preload("res://scenes/key_icon.tscn").instantiate()
			key_icon.name = item
			inventory_grid.add_child(key_icon)
			
func remove_from_carried_inventory(item:String):
		match item:
			"tape":
				tape_icon.queue_free()
			"fuse":
				fuse_icon.queue_free()				
			"lantern":
				lantern_icon.queue_free()	
			"key":
				key_icon.queue_free()	
				
func static_transition_in():
	$StaticRect.visible = true
	$StaticAnim.play("static_in")

func static_transition_out():
	$StaticRect.visible = true
	$StaticAnim.play("static_out")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.




func _on_static_anim_animation_finished(anim_name):
	if anim_name == "static_in":
		emit_signal("screen_is_hidden") 
		var yield_timer_b = Timer.new()
		add_child(yield_timer_b)
		yield_timer_b.start(3);
		await yield_timer_b.timeout
		static_transition_out()
	elif anim_name == "static_out":
		emit_signal("can_load_now")
		GlobalSignals.emit_signal("zoom_out_from_tv")
		


func display_locked():
	if %Locked.visible == true:
		return
	%Locked.visible = true
	var locked_timer = Timer.new()
	add_child(locked_timer)
	locked_timer.start(1.2);
	await locked_timer.timeout
	print ("lock timer out")
	locked_timer.queue_free()
	%Locked.visible = false
	

func cover_fade(amount:float):
	
	var fade_to: float = 0.0
	if amount < 10:
		fade_to = (1/amount) * 1.3
	#print ("cover fade "+str(fade_to))
	var tween = create_tween()
	# You can access specific properties like so:
	tween.tween_property(%FadeCover, "modulate:a", fade_to, 1.0)


func cover_fade_death():
	print ("FADE DEATH")
	var tween = create_tween()
	# You can access specific properties like so:
	tween.tween_property(%FadeCover, "modulate:a", 1.0, 1.0)
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	call_deferred("_restart_game")

func _restart_game():
	GlobalVars.key_count = 0
	get_tree().reload_current_scene()

func _menu_cover_enter(state):
	print ("MENU FADE COVER")
	if state:
		var tween = create_tween()
		tween.tween_property(%MenuOverlay, "modulate:a", 0.5, 1.0)
		%menubtn.disabled = false
		%menubtn.visible = true
		%menubtn.mouse_filter = MOUSE_FILTER_STOP
	else:
		%menubtn.disabled = true
		%menubtn.mouse_filter = MOUSE_FILTER_IGNORE
		%menubtn.visible = false
		%MenuOverlay.modulate.a = 0
	#tween.connect("finished", on_tween_finished)	

func _on_menubtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
