extends Node

signal add_to_inventory(item:String)
signal remove_from_inventory(item:String)

signal update_key(count:int)

signal change_scene(scene_name:String)

signal cut_scene(state:bool)

signal tape_1_set_up()
signal tape_2_set_up()
signal tape_3_set_up()
signal tape_4_set_up()

signal lever_set_up()
signal fuse_set_up()
signal lamp_set_up()

signal zoom_out_from_tv()

signal bake_nav()

signal splash_sound()
signal enemy_state(state:String)
signal manual_state_trigger(state:String, buzz_no: int)

signal buzz_kill(buzz: int)

signal key_press(key: String)
signal keypad_code(code: String)

signal elevator_open()
signal elevator_close()

signal parent_to_elevator()

signal end_game()

signal noise_level_show(level)

signal bridge_show(state: bool)

signal cave_body_off(state)


signal check_one()
signal check_two()
signal check_three()
signal check_four()

signal teleport(direction)
signal secret_area(state)

signal key_show(state)
