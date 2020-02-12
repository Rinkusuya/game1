extends RigidBody2D

var timePassed = 0
const MAXTIMEPASSED = 4
var attackDamage = 40


func _ready():
	apply_central_impulse(Vector2.UP*960)
	#add_to_group("affected_by_time")

func _physics_process(delta):
	#var trueDelta = delta
	#delta = delta*_time_multiplier
	
	timePassed += delta
	if timePassed >= MAXTIMEPASSED:
		queue_free()
	#for body in get_colliding_bodies():
	#	body.hit(self)