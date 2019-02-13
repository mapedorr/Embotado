extends Node2D

export (PackedScene) var instruction_type


export (float) var MX_BPM
export (int) var Time
export (int) var Measure
export(Array, int, FLAGS, "1,2,3,4,5,6") var notes setget notes_set, notes_get
export(Array, int, FLAGS, "1,2,3,4,5,6") var Level1
export(Array, int, FLAGS, "1,2,3,4,5,6") var Level2
export(Array, int, FLAGS, "1,2,3,4,5,6") var Level3

var eval_array
var dbg
var beat
var last_beat
var metronome_count
var current_bar
var metronome_measure
var notes_array
var bars_line
var line_count
var currentLevel = 1

func _ready():
	notes = Level1
	# Called when the node is added to the scene for the first time.
	eval_array = []
	dbg = $"../../Debug"
	beat = 0
	last_beat = 0
	metronome_count = 1
	notes_array = [false, false, false, false, false, false]
	bars_line = [3, 3, 3, 3, 2, 0, 0, 0]
	line_count = 0

	metronome_measure = Time
	$Metronome.wait_time = (60 * 1) / MX_BPM / 2

func change_level():
	print ("Level"+String(currentLevel))
	currentLevel += 1
	#var level_array = "Level"+String(currentLevel)
	#notes = level_array 

	


func setup_metronome():
	$Metronome.wait_time = (60 * Time) / MX_BPM / 2

func _on_Metronome_timeout():
	if metronome_count > metronome_measure:
		metronome_count = 1
		#$"../Detector".play_music()
		# Clear the notes
		notes_array = [false, false, false, false, false, false]
		
		var random_pattern = randi() % notes.size()
		var fixed_pattern = 0

		# Check if there's a note for the current beat
		# Casiila: 1 2 3 4  5  6
		# Valor:   1 2 4 8 16 32

		match notes[random_pattern]:
			1:
				# Create a whole note
				notes_array[0] = true
				dbg.label("Symbol", "Compás: redonda + blanca")
			9:
				# Create a a white note, then a whole note
				notes_array[0] = true
				notes_array[3] = true
				dbg.label("Symbol", "Compás: 2 negras con puntillo")
			17:
				# Create a whole note, then a white note
				notes_array[0] = true
				notes_array[4] = true
				dbg.label("Symbol", "Compás: 1 redonda, 1 blanca")
			21:
				# Create 3 white notes
				notes_array[0] = true
				notes_array[2] = true
				notes_array[4] = true
				dbg.label("Symbol", "Compás: 3 blancas")
			
			42:
				notes_array[1] = true
				notes_array[3] = true
				notes_array[5] = true
			
			63:
				# Create 6 negras
				notes_array[0] = true
				notes_array[1] = true
				notes_array[2] = true
				notes_array[3] = true
				notes_array[4] = true
				notes_array[5] = true
				dbg.label("Symbol", "Compás: 6 negras")
		line_count += 1 if line_count < bars_line.size() - 1 else -line_count

	if notes_array[metronome_count - 1]:
		create_instruction()

	metronome_count += 1

func create_instruction():
	var instruction_i = instruction_type.instance()
	instruction_i.position.x = self.position.x
	instruction_i.position.y = self.position.y
	# Get a random letter for the instantiated Instruction
	var random_index = randi() % $"../".keys.size()
	var letter = $"../".get_letter(random_index)
	# var random_index = randi() % instruction_i.TYPES.size()
	# var letter = instruction_i.TYPES[random_index]
	instruction_i.initialize({
		"target": $Target,
		"letter": letter,
		"tween_duration": Measure
	})
	eval_array.append(instruction_i)
	get_parent().add_child(instruction_i)
	instruction_i.appear()

func notes_set(new_value):
	notes = new_value

func notes_get():
	return notes