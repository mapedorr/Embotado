extends Node2D

var local_score = 0

export(Array, int, "A", "S", "D", "F", "H", "J", "K", "L") var keys = [65, 83, 68, 70, 72, 74, 75, 76]

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
		"key_code": 70,
		"character": "F"
	},
	4: {
		"key_code": 72,
		"character": "H"
	},
	5: {
		"key_code": 74,
		"character": "J"
	},
	6: {
		"key_code": 75,
		"character": "K"
	},
	7: {
		"key_code": 76,
		"character": "L"
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
	print(local_score)
	if local_score > 5:
		$Spawner.change_level()