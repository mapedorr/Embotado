extends Node2D

var on_area
var spawner
var d_goal
var d_input
var current_letter
var current_checked

func _ready():
	on_area = false
	spawner = get_node("../Spawner")
	d_goal = get_node("../Debug/Goal")
	d_input = get_node("../Debug/Input")
	current_checked = false

func _process(delta):
	if spawner.eval_array.size() > 0:
		current_letter = spawner.eval_array[0].letter
		d_goal.text = "Evaluando " + current_letter
		match current_letter:
			"A":
				check_press(KEY_A)
			"S":
				check_press(KEY_S)
			"D":
				check_press(KEY_D)
			"F":
				check_press(KEY_F)

func check_press(key_code):
	if Input.is_key_pressed(key_code) and not current_checked:
		current_checked = true
		if on_area:
			spawner.eval_array[0].get_node("Sprite").modulate = Color("7bccc4")
			d_input.text = "Buena malparido. Buena."
		else:
			spawner.eval_array[0].get_node("Sprite").modulate = Color("b84042")
			d_input.text = "¡Qué piró tan bobo!"

func _on_Area2D_area_entered(area):
	on_area = true

func _on_Area2D_area_exited(area):
	on_area = false
	current_checked = false
	# Change the letter to evaluate
	change_letter()

func change_letter():
	spawner.eval_array.pop_front()
	if spawner.eval_array.size() > 0:
		d_goal.text = "Evaluando " + spawner.eval_array[0].letter
	else:
		d_goal.text = "Nada para evaluar"