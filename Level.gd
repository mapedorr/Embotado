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
var count = true

func _ready():
	# Called when the node is added to the scene for the first time.
	

	$Debug.visible = debug
	Level = 0
	goal = 15
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
		count = true
		metronome_count = 1
		if is_playing == false:
			$MusicSystem.playMx()
			is_playing = true
		if bar_count == 9:
			Level = 1
			$MusicSystem.stopMx()
			$MusicSystem.levelChange()
			$MusicSystem.playMx()
			
		panda_spawner.setup_notes_array()
		rhyno_spawner.setup_notes_array()


	if is_playing:
		panda_spawner.create_note(metronome_count)
		rhyno_spawner.create_note(metronome_count)
		if score > goal:

			if Level == 1:
				goal = 45
			if Level == 2:
				goal = 70
			
			if Level ==3:
				$MusicSystem.stopMx()
			
			$MusicSystem.stopMx()
			$MusicSystem.levelChange()
			if Level < 3:
				panda_spawner.change_level()
				rhyno_spawner.change_level()
				$MusicSystem.playMx()
			Level += 1
			
			
			 
		
		

	metronome_count += 1
	if count == true:
		bar_count += 1
		count = false