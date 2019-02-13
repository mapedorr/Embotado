extends Node

export(bool) var debug = false

export(int) var BPM 

var score

var metronome_measure = 6

var metronome_count = 1

var bar_count = 0

var is_playing = false

func _ready():
	# Called when the node is added to the scene for the first time.
	$Debug.visible = debug
	score = 0
	update_score(score)
	$Metronome.wait_time = 0.30

func setup_metronome():
	$Metronome.wait_time = (60 * 1) / BPM / 2

func update_score(new_score):
	score += new_score
	score = max(score, 0)
	$Score.text = "Score: %s" % score
func _on_Metronome_timeout():
	metronome_count += 1
	if bar_count == 1:
		if is_playing == false:
			$MX.play()
			is_playing = true
	if metronome_count > metronome_measure:
		bar_count += 1
		metronome_count = 1
		
	
