extends CommonEnemy

const GRAVITY = 640
const JUMPFORCE = 480
const WALKSPEED = 64*4
const STARTINGLIFE = 30
const MAXTIMEONGROUND = 0.5
export(String) var walking = "L"
var vel = Vector2.ZERO
var timeElapsed = 0.0
var _paused = false

func _ready():
	_commonEnemy_ready(STARTINGLIFE, 20)
	if walking == "R":
		$Sprite.flip_h = true

func _physics_process(delta):
	._physics_process(delta)
	
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if not out_of_bounds and not waitingToExitSpawnPoint and not _paused:
		vel.x = (1 if walking == "R" else -1)*WALKSPEED*_time_multiplier
		
		if is_on_floor():
			if $AnimationPlayer.current_animation == "onAir":
				$AnimationPlayer.play("onGround")
			timeElapsed += delta
			if timeElapsed >= MAXTIMEONGROUND:
				timeElapsed = 0.0
				vel += _floor()*JUMPFORCE*_time_multiplier
		else:
			if $AnimationPlayer.current_animation == "onGround":
				$AnimationPlayer.play("onAir")
		
		vel += _gravity_vect*GRAVITY*delta*_time_multiplier
		
		vel = move_and_slide(vel, _floor())
		collisionDetection()

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
