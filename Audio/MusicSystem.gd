extends Node

export (bool) var AutoPlay = false

export (float) var waitTime = 0


var Mute = false

var index_track = 0
var music_to_play
var timeout = waitTime
var Level
var is_playing = false 


func _ready():
	Level = 0
	music_to_play = $Intro
	#randomize()
	#if (AutoPlay == true):
		#index_track = randi()%get_child_count()
		#music_to_play = get_child(index_track)
		#playMx()
	

func playMx():
	music_to_play.playmusic()

func stopMx():
	music_to_play.stopmusic()

func levelChange():
	Level += 1
	if Level == 1:
		music_to_play = $Level1
	if Level == 2:
		music_to_play = $Level2
	if Level == 3:
		music_to_play = $Level3
	

func Mute():
	if Mute == false:
		AudioServer.set_bus_mute (1, true)
		Mute = true
	else:
		AudioServer.set_bus_mute (1, false)
		Mute = false


#func nextSong():
#	index_track += 1
#	if index_track >= get_child_count():
#		index_track = 0
#	playMx()


#func prevSong():
#	index_track -= 1
#	if index_track < 0:
#		index_track = get_child_count() - 1
#	playMx()


#func _process(delta):
#	timeout -= delta
#	if timeout < 0:
#		nextSong()
#		timeout = waitTime

