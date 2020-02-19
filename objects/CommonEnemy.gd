extends GameEntity

class_name CommonEnemy

export(bool) var RepetitiveSpawning = false

var out_of_bounds = true

var drop = preload("res://objects/Drop.tscn")
var checkpoint_gpos
var waitingToExitSpawnPoint = false

# Ready
func _commonEnemy_ready(initLife : int, atkDmg : int):
	_gameEntity_ready(initLife)
	checkMethod("enteredScreen", true)
	checkMethod("exitedScreen", true)
	attackDamage = atkDmg
	checkpoint_gpos = global_position

func _physics_process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if life <= 0:
		return
	
	var camera_vect = level.camera.global_position-global_position
	
	if level.camera:
		if abs(camera_vect.x) > 480+64 or abs(camera_vect.y) > 320+64:
			if waitingToExitSpawnPoint:
				waitingToExitSpawnPoint = false
			if not out_of_bounds:
				out_of_bounds = true
				exitedScreen()
		elif abs(camera_vect.x) < 480 or abs(camera_vect.y) < 320:
			if out_of_bounds:
				out_of_bounds = false
				if not waitingToExitSpawnPoint:
					enteredScreen()

func collisionDetection():
	for i_collision in range(0, get_slide_count()):
		var collision = get_slide_collision(i_collision)
		if collision:
			var obj : Node2D = collision.collider
			if obj.get_collision_layer_bit(4):
				hit(obj)
				obj.hit(self)
			elif obj.get_collision_layer_bit(2):
				obj.hit(self)
			else:
				additionalCollisionDetection(collision, obj)
				
func additionalCollisionDetection(collision, obj):
	pass

func enteredScreen():
	noObjectError("enteredScreen")

func exitedScreen():
	noObjectError("exitedScreen")

func respawn():
	global_position = checkpoint_gpos
	if not RepetitiveSpawning:
		waitingToExitSpawnPoint = true

func die():
	level.dispensableContainer.add_child(drop.instance().init(global_position))