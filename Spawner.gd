extends Node2D

export (PackedScene) var instruction_type

export (float) var MX_BPM
export (int) var Time
export (int) var Measure
export(Array, int, FLAGS, "1,2,3,4,5,6") var notes setget notes_set, notes_get
# export(int, FLAGS, "1,2,3,4,5,6") var notes = 0 setget notes_set, notes_get

var eval_array
var dbg
var beat
var last_beat

func _ready():
	# Called when the node is added to the scene for the first time.
	eval_array = []
	beat = 0
	last_beat = 0
	dbg = $"../Debug"
	
	$Metronome.wait_time = (60 * Time) / MX_BPM
	
	if beat > 0:
		$Timer.wait_time = (60 * Time) / MX_BPM / beat
	else:
		$Timer.wait_time = $Metronome.wait_time

func _on_Metronome_timeout():
	if check_beat(notes[randi() % notes.size()]):
		$Timer.wait_time = (60 * Time) / MX_BPM / beat

func _on_Timer_timeout():
	if instruction_type and beat > 0:
		var instruction_i = instruction_type.instance()
		instruction_i.position.x = self.position.x
		instruction_i.position.y = self.position.y
		# Get a random letter for the instantiated Instruction
		var random_index = randi() % instruction_i.TYPES.size()
		var letter = instruction_i.TYPES[random_index]
		instruction_i.initialize({
			"target": $Target,
			"letter": letter
		})
		eval_array.append(instruction_i)
		get_parent().add_child(instruction_i)
		instruction_i.appear()

func notes_set(new_value):
	notes = new_value

func notes_get():
	return notes

func check_beat(note):
	beat = note
	match note:
		3:
			beat = 2
		7:
			beat = 4
		15:
			beat = Measure
		31:
			beat = Measure * 2
		63:
			beat = Measure * 4
	dbg.label("Symbol", "Figura: " + get_note_name(beat))
	if last_beat != beat:
		return true

func get_note_name(note_measure):
	match note_measure:
		0:
			return "Silencio"
		1:
			return "Redonda"
		2:
			return "Blanca"
		4:
			return "Negra"
		8:
			return "Corchea"
		16:
			return "Semicorchea"
		32:
			return "Fusa"
		64:
			return "Semifusa"