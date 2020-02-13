extends CommonEnemy

var _paused = false
const STARTINGLIFE = 10
var vel = Vector2.ZERO

func _ready():
	_commonEnemy_ready(STARTINGLIFE, 20)
	vel = Vector2(-480, 320)

func _physics_process(delta):
	._physics_process(delta)
	
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if not out_of_bounds and not waitingToExitSpawnPoint and not _paused:
		var collision = move_and_collide(vel*delta)
		if collision:
			vel = -vel.reflect(collision.normal)

func respawn():
	.respawn()
	life = STARTINGLIFE
	vel = Vector2(-480, 320)
	$Sprite/AnimationPlayer.stop()

func damage(atkPower):
	life -= atkPower
	if life <= 0:
		die()

func die():
	.die()
	exitedScreen()

func hit(obj):
	if obj.get_collision_layer_bit(4):
		damage(obj.attackDamage)

func enteredScreen():
	$Sprite/AnimationPlayer.play("default")
	$CollisionShape2D.disabled = false
	visible = true

func exitedScreen():
	respawn()
	$CollisionShape2D.disabled = true
	visible = false

func timeMultiplierChanged():
	$Sprite/AnimationPlayer.playback_speed = _time_multiplier

func pause():
	if not _paused:
		_paused = true
		$Sprite/AnimationPlayer.stop(false)

func resume():
	if _paused:
		_paused = false
		$Sprite/AnimationPlayer.play()
