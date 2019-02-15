extends Node2D

var local_score = 0

export(Array, int, "W", "A", "S", "D") var keys = [
	KEY_W,
	KEY_A,
	KEY_S,
	KEY_D,
	KEY_UP,
	KEY_LEFT,
	KEY_DOWN,
	KEY_RIGHT
]

const LETTERS = {
	0: {
		"key_code": 65,
		"character": "A"
	},
	1: {
		"key_code": 83,
		"character": "S"
	},
	2: {
		"key_code": 68,
		"character": "D"
	},
	3: {
		"key_code": KEY_W,
		"character": "W"
	},
	4: {
		"key_code": KEY_UP,
		"character": "UP"
	},
	5: {
		"key_code": KEY_LEFT,
		"character": "LEFT"
	},
	6: {
		"key_code": KEY_DOWN,
		"character": "DOWN"
	},
	7: {
		"key_code": KEY_RIGHT,
		"character": "RIGHT"
	}
}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print(keys)

func get_letter(code):
	return LETTERS[keys[code]].character

func get_letter_code(_character):
	for key in LETTERS:
		if LETTERS[key].character == _character:
			return LETTERS[key].key_code

func score(area, center):
	var _score = -2
	if area or center:
		_score = 2 if center else 1
	$"../".update_score(_score)
	local_score = _score + local_score
	#if local_score > 5:
	#	$Spawner.change_level()