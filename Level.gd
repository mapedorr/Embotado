extends Node

export(bool) var debug = false
export(float) var MX_BPM 

var barTime

var score
var metronome_measure = 6
var metronome_count = 1
var bar_count = 0
var is_playing = false
var panda_spawner
var rhyno_spawner
var Level
var goal

func _ready():
	# Called when the node is added to the scene for the first time.
	

	$Debug.visible = debug
	Level = 1
	goal = 20
	score = 0
	barTime = 60/MX_BPM/2
	panda_spawner = $Panda/Spawner
	rhyno_spawner = $Rhyno/Spawner
	$Metronome.wait_time = barTime
	$Metronome.start()
	update_score(score)

	

func setup_metronome():
	$Metronome.wait_time = barTime

func update_score(new_score):
	score += new_score
	score = max(score, 0)
	$Score.text = "Score: %s" % score

func _on_Metronome_timeout():
	if metronome_count > metronome_measure:
		bar_count += 1
		metronome_count = 1
		if is_playing == false:
			$MusicSystem.playMx()
			is_playing = true
		panda_spawner.setup_notes_array()
		rhyno_spawner.setup_notes_array()


	if is_playing:
		if score > goal:
			change_levelMX()
		
		panda_spawner.create_note(metronome_count)
		rhyno_spawner.create_note(metronome_count)

	metronome_count += 1
	
func change_levelMX():
	$MusicSystem/Level1.stopmusic()
	$MusicSystem/Level1_Ending.playmusic()
	goal = goal + goal