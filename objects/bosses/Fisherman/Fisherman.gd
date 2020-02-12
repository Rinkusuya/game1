extends Kin2D_TimeManipulable

var life = 100

func _ready():
	_timeManipulable_ready()

func _time_multiplier_changed():
	$Sprite/AnimationPlayer.playback_speed = _time_multiplier

func entrance():
	$Sprite/AnimationPlayer.play("entrance")

func start():
	$Sprite/AnimationPlayer.play("bumpy")

func bumpFinish():
	pass