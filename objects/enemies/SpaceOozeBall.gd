extends CommonEnemy

var _paused = false
const STARTINGLIFE = 10

func _ready():
	_commonEnemy_ready(STARTINGLIFE, 20)

func respawn():
	.respawn()
	life = STARTINGLIFE
	$AnimationPlayer.stop()

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
	$AnimationPlayer.play("onAir")
	$CollisionShape2D.disabled = false
	visible = true

func exitedScreen():
	respawn()
	$CollisionShape2D.disabled = true
	visible = false

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier

func pause():
	if not _paused:
		_paused = true
		$AnimationPlayer.stop(false)

func resume():
	if _paused:
		_paused = false
		$AnimationPlayer.play()
