extends CommonEnemy

var _paused = false
var i = 0
var pickaxe = preload("res://objects//weapons//Pickaxe.tscn")
export(String) var Facing = "L"
var vel = Vector2.ZERO

var checkpoint_facing

var isAttacking = false
var _animIsPlaying_saved = false

const GRAVITY = 3200
const WALKSPEED = 64*2
const JUMPFORCE = 640
const STARTINGLIFE = 50

func _ready():
	_commonEnemy_ready(STARTINGLIFE, 20)
	checkpoint_facing = Facing

func _physics_process(delta):
	._physics_process(delta)
	
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if not out_of_bounds and not waitingToExitSpawnPoint and not _paused:
		
		var player_vect = level.player.global_position-global_position
		
		if player_vect.x > 0 and Facing == "L":
			Facing = "R"
			$Sprite.scale.x = -1
		elif player_vect.x < 0 and Facing == "R":
			Facing = "L"
			$Sprite.scale.x = 1
		
		if not isAttacking:
			vel.x = _time_multiplier*(-1 if Facing == "R" else 1)*pow(280-abs(player_vect.x), 3)
		
		if abs(vel.x) > WALKSPEED:
			vel.x = _time_multiplier*(1 if vel.x > 0 else -1)*WALKSPEED
		
		vel += _gravity_vect*GRAVITY*delta*_time_multiplier
		
		vel = move_and_slide(vel, _floor())
		collisionDetection()

func stepFinish():
	i += 1
	if i >= 2:
		i = 0
		$AnimationPlayer.play("attack")

func attack(type : String = "Default"):
	var pick = pickaxe.instance()
	isAttacking = true
	pick.init(Vector2(4 if Facing == "R" else -4, -12), _time_multiplier)
	pick.position = position
	level.dispensableContainer.add_child(pick)
	jump()

func walk():
	isAttacking = false
	$AnimationPlayer.play("default")

func jump():
	if is_on_floor():
		vel.y = -JUMPFORCE*_time_multiplier

func respawn():
	.respawn()
	life = STARTINGLIFE
	Facing = checkpoint_facing
	$AnimationPlayer.stop()

func damage(atkPower):
	life -= atkPower
	if life <= 0:
		die()

func die():
	.die()
	exitedScreen()

func hit(obj):
	damage(obj.attackDamage)

func pause():
	if not _paused:
		_paused = true
		if $AnimationPlayer.is_playing():
			_animIsPlaying_saved = true
			$AnimationPlayer.stop(false)
		else:
			_animIsPlaying_saved = false

func resume():
	if _paused:
		_paused = false
		if _animIsPlaying_saved:
			$AnimationPlayer.play()

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier
	vel = vel*_time_multiplier

func enteredScreen():
	$AnimationPlayer.play("default")
	$CollisionShape2D.disabled = false
	var player_vect = level.player.global_position-global_position
	if player_vect.x > 0:
		Facing = "R"
		$Sprite.scale.x = -1
	elif player_vect.x < 0:
		Facing = "L"
		$Sprite.scale.x = 1
	visible = true

func exitedScreen():
	respawn()
	$CollisionShape2D.disabled = true
	visible = false