extends GameObject

var dropType
var timeElapsed = 0.0
const MAXTIMEELAPSED = 10.0
const GRAVITY = 640*4
var paused = false
var vel = Vector2(0, -480)
var toggled = false
var saved_timerRunning = false

func _ready():
	_gameObject_ready()

func init(pos : Vector2, type : String = "Random"):
	
	global_position = pos
	
	if type == "Random":
		randomize()
		var num = randi()%100
		
		if num == 0:
			type = "ExtraLife"
		elif num <= 5:
			type = "BigHealth"
		elif num <= 10:
			type = "BigPURefill"
		elif num <= 20:
			type = "SmallHealth"
		elif num <= 30:
			type = "SmallPURefill"
		
	match type:
		"ExtraLife":
			$Sprite.frame = 24
			$Sprite.scale = Vector2(4, 4)
			$CollisionShape2D_ExtraLife.disabled = false
		"BigHealth": 
			$Sprite.frame = 2
			$CollisionShape2D_BigHealth.disabled = false
			$Timer.start()
		"BigPURefill":
			$Sprite.frame = 14
			$CollisionShape2D_BigPURefill.disabled = false
			$Timer.start()
		"SmallHealth":
			$Sprite.frame = 0
			$CollisionShape2D_SmallHealth.disabled = false
			$Timer.start()
		"SmallPURefill":
			$Sprite.frame = 4
			$CollisionShape2D_SmallPURefill.disabled = false
			$Timer.start()
		_: return null
	dropType = type
	$Sprite.visible = true
	return self

func _physics_process(delta):
	if not paused and dropType:
		timeElapsed += delta
		if timeElapsed >= MAXTIMEELAPSED:
			queue_free()
			#var e = load("res://objects/Drop.tscn").instance()
			#e.global_position = Vector2(1504, 352)
			#get_tree().get_root().add_child(e)
		vel += _gravity_vect*GRAVITY*delta
		vel = move_and_slide(vel, _floor())


func _toggle():
	if toggled:
		toggled = false
		$Sprite.frame -= 1
	else:
		toggled = true
		$Sprite.frame += 1


func pause():
	if not paused:
		paused = true
		if $Timer.is_stopped():
			saved_timerRunning = false
		else:
			saved_timerRunning = true
			$Timer.stop()

func resume():
	if paused:
		paused = false
		if saved_timerRunning:
			$Timer.start()

func _playerTouched(body):
	if body == level.player:
		match dropType:
			"ExtraLife":
				level.player.extraLife()
			"BigHealth":
				level.player.heal(80)
			"BigPURefill":
				level.player.refill("Big")
			"SmallHealth":
				level.player.heal(20)
			"SmallPURefill":
				level.player.refill("Small")
			_:
				pass
		queue_free()