extends Node2D
onready var Explosion_Fail = preload("res://Explosion_Fail.tscn")


export(float) var MX_BPM

var tween_duration

var movement_target
var letter
var detector

const TYPES = ["A", "S", "D", "F", "H", "J", "K", "L"]
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
#	tween_duration = init_data.tween_duration
	
	# Assign the proper texture based on the assigned letter
	$Sprite.texture = load(SPRITES_PATH % letter)

func appear():
	$Tween.interpolate_property(
		self,
		"position",
		self.position,
		movement_target.position,
		tween_duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()

func fail():
	var ExpPart = Explosion_Fail.instance()
	add_child(ExpPart)
	ExpPart.emitting = true
	hide_particle()

func hide_particle():
	$Particles2D.visible = false
#func center():
	#$Particles2D.visible = false


func _on_Tween_tween_completed(object, key):
	self.queue_free()

func _on_Instruction_tree_entered():
	print ('apareci pirobos')

