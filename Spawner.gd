extends Node2D

export (PackedScene) var instruction_type


export (float) var MX_BPM
export (int) var Time
export (int) var Measure

var eval_array

func _ready():
	# Called when the node is added to the scene for the first time.
	eval_array = []
	$Timer.wait_time = (60*(Time))/MX_BPM/2
	print ($Timer.wait_time)
	pass

func _on_Timer_timeout():
	if instruction_type:
		var instruction_i = instruction_type.instance()
		instruction_i.position.x = self.position.x
		instruction_i.position.y = self.position.y
		# Get a random letter for the instantiated Instruction
		var random_index = randi() % instruction_i.TYPES.size()
		var letter = instruction_i.TYPES[random_index]
		instruction_i.initialize({
			"target": $Target,
			"letter": letter
		})
		eval_array.append(instruction_i)
		get_parent().add_child(instruction_i)
		instruction_i.appear()
