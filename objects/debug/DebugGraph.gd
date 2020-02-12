extends Node2D

var me = load("res://objects//debug//DebugGraph.tscn")
var time = 0
var batton_passed = false
#var ready = false

var target
#var variable

func _ready():
	pass

func setTarget(t):
	target = t
	return self

func _physics_process(delta):
	#print(target)
	if time < 0.1 and target:
		time += delta
		#print(time)
		global_position = target.global_position
		#position.x += 1
		#position.y = 640 - variable*0.5
	elif (not batton_passed) and target:
		get_tree().get_root().add_child(me.instance())
		batton_passed = true
		#print("E")
