extends Projectile

var _paused = false
var vel = Vector2(0, 0)
const GRAVITY = 24

func _ready():
	_projectile_ready(20)

func init(vect : Vector2, time_mult : float):
	_time_multiplier = time_mult
	vel = vect
	if vel.x > 0:
		$Sprite.flip_h = true
		$AnimationPlayer.play_backwards("rotate")
	else:
		$AnimationPlayer.play("rotate")

func _physics_process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if not _paused:
		_projectile_physics_process(delta, trueDelta)
		
		if vel:
			vel += _gravity_vect*GRAVITY*delta
			var col = move_and_collide(vel*_time_multiplier)
			if col and col.collider.get_collision_layer_bit(2):
				# Hit Player!
				col.collider.hit(self)

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier
	#vel = vel*_time_multiplier

func hit(body : KinematicBody2D):
	pass

func pause():
	if not _paused:
		_paused = true
		$AnimationPlayer.stop(false)

func resume():
	if _paused:
		_paused = false
		$AnimationPlayer.play()