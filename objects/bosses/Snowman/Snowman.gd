extends Kin2D_TimeManipulable

var life = 100
var vel

func _ready():
	_timeManipulable_ready()
	$Body/AnimationPlayer.play("windy")

func entrance():
	if not $Body/AnimationPlayer.is_playing():
		$Body/AnimationPlayer.play("windy")
	$Head/AnimationPlayer.play("entrance")

func start():
	$Head/AnimationPlayer.play("headBump")

func bumpFinish():
	pass

func _time_multiplier_changed():
	$AnimationPlayer.playback_speed = _time_multiplier
	$SmearPlayer.playback_speed = _time_multiplier
	vel = vel*pow(_time_multiplier, 2)