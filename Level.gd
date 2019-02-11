extends Node

export(bool) var debug = false

func _ready():
	# Called when the node is added to the scene for the first time.
	$Debug.visible = debug