extends Node2D

onready var Explosion = preload("res://Explosion.tscn")

export (int) var center_threshold = 6

var on_area
var spawner
var d_goal
var d_input
var current_letter
var current_checked
var checked
var is_playing = false
var SFX
var dbg
var instruction_area
var on_center
var currentInstruction
var nextInstruction
var existance

func _ready():
	# Called when the node is added to the scene for the first time.
	on_area = false
	on_center = false
	spawner = $"../Spawner"
	dbg = $"../../Debug"
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
		# dbg.label("Goal", "Evaluando " + current_letter)

		check_press($"../".get_letter_code(current_letter))
		match current_letter:
			"W":
				SFX = $F
			"A":
				SFX = $A
			"S":
				SFX = $S
			"D":
				SFX = $D
			"UP":
				SFX = $H
			"LEFT":
				SFX = $J
			"DOWN":
				SFX = $K
			"RIGHT":
				SFX = $L

func play_music():
	if is_playing == false:
		$MX.play()
		is_playing = true

func check_press(key_code):
	if Input.is_key_pressed(key_code) and not current_checked:
		current_checked = true
		
		if on_area:
			checked = true
			if on_center:
				# TODO: play something special?
				$SFX_Pos.playsound()
				currentInstruction = instruction_area.get_parent()
				currentInstruction.hide_particle()
				var ExpPart = Explosion.instance()
				add_child(ExpPart)
				ExpPart.emitting = true
				instruction_area.get_node("../Sprite").set_scale(Vector2(0, 0))
			SFX.play()
			$SFX_Whoosh.playsound()
			spawner.eval_array[0].get_node("Sprite").modulate = Color("7bccc4")
			var last_frame = $"../Sprite".frame
			match key_code:
				KEY_W, KEY_UP:
					$"../Sprite".frame = 4
				KEY_A, KEY_LEFT:
					$"../Sprite".frame = 0
				KEY_S, KEY_DOWN:
					$"../Sprite".frame = 3
				KEY_D, KEY_RIGHT:
					$"../Sprite".frame = 1
			if last_frame == $"../Sprite".frame:
				$"../Sprite".flip_h = true
			else:
				$"../Sprite".flip_h = false
		else:
			# nextInstruction.fail()
			checked = true
			spawner.eval_array[0].fail()
			$SFX_Neg.playsound()
			spawner.eval_array[0].get_node("Sprite").modulate = Color("b84042")
			spawner.eval_array[0].get_node("Sprite").set_scale(Vector2(0, 0))
		$"../".score(on_area, on_center)

func _on_Area2D_area_entered(area):
	checked = false
	instruction_area = area
	on_area = true

func _on_Area2D_area_exited(area):
	instruction_area = null
	on_area = false
	current_checked = false

	if checked == false:
		spawner.eval_array[0].fail()
		$SFX_Neg.playsound()
		spawner.eval_array[0].get_node("Sprite").set_scale(Vector2(0, 0))
		$"../".score(on_area, on_center)
		
	# Change the letter to evaluate
	change_letter()

func change_letter():
	spawner.eval_array.pop_front()
	# if spawner.eval_array.size() > 0:
	# 	dbg.label("Goal", "Evaluando " + spawner.eval_array[0].letter)
	# else:
	# 	dbg.label("Goal", "Nada para evaluar")