extends Node2D

export (int) var center_threshold = 6
onready var Explosion = preload("res://Explosion.tscn")

var on_area
var spawner
var d_goal
var d_input
var current_letter
var current_checked
var is_playing = false
var SFX
var dbg
var instruction_area
var on_center

func _ready():
	# Called when the node is added to the scene for the first time.
	on_area = false
	on_center = false
	spawner = $"../Spawner"
	dbg = $"../Debug"
	current_checked = false
	
	dbg.label("Goal", "")
	dbg.label("Input", "")

func _process(delta):
	if on_area:
		# check if the Instruction is centered
		$Center.points[1] = self.to_local(instruction_area.global_position)
		on_center = false
		if floor($Center.points[0].distance_to($Center.points[1])) <= center_threshold:
			on_center = true
	
	if spawner.eval_array.size() > 0:
		current_letter = spawner.eval_array[0].letter
		dbg.label("Goal", "Evaluando " + current_letter)
		match current_letter:
			"A":
				check_press(KEY_A)
				SFX = $A
			"S":
				check_press(KEY_S)
				SFX = $S
			"D":
				check_press(KEY_D)
				SFX = $D
			"F":
				check_press(KEY_F)
				SFX = $F

func play_music():
	if is_playing == false:
		$MX.play()
		is_playing = true

func check_press(key_code):
	if Input.is_key_pressed(key_code) and not current_checked:
		current_checked = true
		if on_area:
			if on_center:
				# TODO: play something special?
				var ExpPart = Explosion.instance()
				add_child(ExpPart)
				ExpPart.emitting = true
				instruction_area.get_node("../Sprite").set_scale(Vector2(0.4, 0.4))
			SFX.play()
			spawner.eval_array[0].get_node("Sprite").modulate = Color("7bccc4")
			dbg.label("Input", "Buena malparido. Buena.")
		else:
			spawner.eval_array[0].get_node("Sprite").modulate = Color("b84042")
			dbg.label("Input", "¡Qué piró tan bobo!")
		# spawner.eval_array[0].get_node("Area2D").queue_free()

func _on_Area2D_area_entered(area):
	instruction_area = area
	on_area = true

func _on_Area2D_area_exited(area):
	instruction_area = null
	on_area = false
	current_checked = false
	# Change the letter to evaluate
	change_letter()

func change_letter():
	spawner.eval_array.pop_front()
	if spawner.eval_array.size() > 0:
		dbg.label("Goal", "Evaluando " + spawner.eval_array[0].letter)
	else:
		dbg.label("Goal", "Nada para evaluar")