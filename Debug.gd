extends Control

func label(name, value):
	if has_node(name):
		get_node(name).visible = true
		get_node(name).text = value
