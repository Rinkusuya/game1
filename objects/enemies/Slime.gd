extends CommonEnemy

var _paused = false
var effects = []
const WALKSPEED = 64*4
const STARTINGLIFE = 30
const RUNMULTIPLIER = 3
const RANGE = 32
export(String) var walking = "L"
var checkpoint_walking
var move = false

func _ready():
	_commonEnemy_ready(STARTINGLIFE, 20)
	if walking == "R":
		$Sprite.flip_h = true
	checkpoint_walking = walking
	for i in range(1, 26):
		effects.append(load("res://assets/audio/SlimeSounds/mud_"+str(i).pad_zeros(2)+".ogg"))

func _physics_process(delta):
	._physics_process(delta)
	
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if move and not _paused:
		var player_vectYabs = abs((global_position - level.player.global_position).y)
		var playerInRange = true if player_vectYabs < RANGE else false
		move_and_slide(Vector2((RUNMULTIPLIER if playerInRange else 1)*(1 if walking == "R" else -1)*WALKSPEED, 0)*_time_multiplier, _floor())
		collisionDetection()

func additionalCollisionDetection(collision, obj):
	if obj.get_collision_layer_bit(0):
		switchSides()
		goDown()

func upEnd():
	move = true
	$AnimationPlayer.play("move")

func goUp():
	$AnimationPlayer.play("up")
	$CollisionShape2D.disabled = false

func goDown():
	move = false
	$AnimationPlayer.play("down")
	$CollisionShape2D.disabled = true

func switchSides():
	if walking == "L":
		$Sprite.flip_h = true
		walking = "R"
	else:
		$Sprite.flip_h = false
		walking = "L"

func respawn():
	.respawn()
	life = STARTINGLIFE
	walking = checkpoint_walking
	$AnimationPlayer.stop()
	$AudioStreamPlayer.stop()

func damage(atkPower):
	life -= atkPower
	if life <= 0:
		die()

func die():
	.die()
	exitedScreen()

func hit(obj):
	if obj.get_collision_layer_bit(2):
		goDown()
	if obj.get_collision_layer_bit(4):
		damage(obj.attackDamage)

func enteredScreen():
	$AnimationPlayer.play("up")
	$CollisionShape2D.disabled = false
	_playNewEffect()
	visible = true

func exitedScreen():
	respawn()
	move = false
	$CollisionShape2D.disabled = true
	visible = false

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier

func _playNewEffect():
	randomize()
	$AudioStreamPlayer.stream = effects[randi()%25]
	#$AudioStreamPlayer.play()

func pause():
	if not _paused:
		_paused = true
		$AnimationPlayer.stop(false)
		#$AudioStreamPlayer.stop()

func resume():
	if _paused:
		_paused = false
		$AnimationPlayer.play()
		#$AudioStreamPlayer.play()
