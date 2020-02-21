extends CommonEnemy

const GRAVITY = 640*6
const JUMPFORCE = 640*2
const STARTINGLIFE = 60
var vel = Vector2.ZERO
var timeElapsed = 0.0
var _paused = false
var wokeUp = false

func _ready():
	_commonEnemy_ready(STARTINGLIFE, 40)

func _physics_process(delta):
	._physics_process(delta)
	
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if not _paused and not out_of_bounds and not waitingToExitSpawnPoint and wokeUp:
		
		#Horizontal Movement after player when on air
		if not is_on_floor():
			vel.x += (level.player.global_position.x - global_position.x)*delta*2.0
		
		#Gravity
		vel += _gravity_vect*GRAVITY*delta*_time_multiplier
		
		vel = move_and_slide(vel, _floor())
		collisionDetection()
		
		#Landing Detection
		if $AnimationPlayer.current_animation == "jump" and is_on_floor():
			$AnimationPlayer.play("landing")
			vel.x = 0.0


func _on_PlayerDetectionArea2D_body_entered(body):
	if level.player == body and not $PlayerDetectionArea2D/CollisionShape2D.disabled:
		$PlayerDetectionArea2D/CollisionShape2D.disabled = true
		$AnimationPlayer.play("wokeUp")

func jump():
	vel += _floor()*JUMPFORCE*_time_multiplier
	vel.x += (120.0 if level.player.global_position.x - global_position.x>0 else -120.0)

func wokeUp():
	yield($AnimationPlayer, "animation_finished")
	if not _paused:
		wokeUp = true

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
	if obj.get_collision_layer_bit(4) and wokeUp:
		damage(obj.attackDamage)

func enteredScreen():
	$AnimationPlayer.play("sleeping")
	$CollisionShape2D.disabled = false
	$PlayerDetectionArea2D/CollisionShape2D.disabled = false
	visible = true

func exitedScreen():
	respawn()
	$CollisionShape2D.disabled = true
	visible = false
	vel = Vector2.ZERO
	move_and_slide(vel)
	timeElapsed = 0.0
	wokeUp = false

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