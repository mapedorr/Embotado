extends Node

export(bool) var debug = false

func _ready():
	$Debug.visible = debug
	for label in $Debug.get_children():
		label.text = ""
