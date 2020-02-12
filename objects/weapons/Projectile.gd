extends GameObject

class_name Projectile

const LIFETIME = 2
var _timealive = 0

func _projectile_ready(damage : int):
	_gameObject_ready()
	attackDamage = damage
	if not is_in_group("projectile"):
		add_to_group("projectile")

func _projectile_physics_process(delta, trueDelta):
	
	_timealive += delta
	if _timealive > LIFETIME:
		#print("death by lifetime")
		queue_free()
	
	if level.camera:
		var vect = global_position-level.camera.global_position
		if abs(vect.x) > 480 or abs(vect.y) > 320:
			#print("death by out-of-camera")
			queue_free()