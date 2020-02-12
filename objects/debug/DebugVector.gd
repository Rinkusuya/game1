extends Node2D

var root = Vector2(0, 0)
var vect = Vector2(0, 0)

func _ready():
	#print(Vector2.RIGHT.angle()*180/PI)
	pass

func _physics_process(delta):
	global_position = root
	scale.y = vect.length()
	rotation = vect.angle() + PI/2

func set_root(new_root):
	root = new_root

func set_vector(new_vect):
	vect = new_vect