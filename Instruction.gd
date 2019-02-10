extends Node2D

export(float) var MX_BPM

var tween_duration

var movement_target
var letter

const TYPES = ["A", "S", "D", "F"]
const SPRITES_PATH = "res://Sprites/tile%s.png"

# Called when the node is added to the scene for the first time.
func _ready():
	
	tween_duration = (60*12)/MX_BPM
	
	
	self.visible = true

# Called after the Node is instantiated by Level/Spawner
func initialize(init_data):
	self.visible = false
	movement_target = init_data.target
	letter = init_data.letter
	
	# Assign the proper texture based on the assigned letter
	$Sprite.texture = load(SPRITES_PATH % letter)

func appear():
	$Tween.interpolate_property(
		self,
		"position",
		self.position,
		movement_target.global_position,
		tween_duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	self.queue_free()