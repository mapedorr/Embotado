extends Node

export(bool) var debug = false

var score

func _ready():
	# Called when the node is added to the scene for the first time.
	$Debug.visible = debug
	score = 0
	update_score(score)

func update_score(new_score):
	score += new_score
	score = max(score, 0)
	$Score.text = "Score: %s" % score