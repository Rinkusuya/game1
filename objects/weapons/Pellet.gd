extends Projectile

var movDir = Vector2(0, 0)
const BULLETSPEED = 640*2

func _ready():
	_projectile_ready(10)

func _physics_process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	_projectile_physics_process(delta, trueDelta)
	
	
	var col = move_and_collide(movDir*BULLETSPEED*delta)
	
	if col and col.collider.get_collision_layer_bit(3):
		col.collider.hit(self)
		hit(col.collider)
	

func shoot(posVect : Vector2, dirVect : Vector2, time_mult : float):
	position = posVect
	movDir = dirVect
	_time_multiplier = time_mult

func hit(body):
	set_collision_layer_bit(4, false)
	queue_free()

func timeMultiplierChanged():
	pass