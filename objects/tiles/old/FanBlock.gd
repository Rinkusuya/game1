extends Static2D_TimeManipulable

func _ready():
	_timeManipulable_ready()

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier

func pause():
	$AnimationPlayer.stop(false)

func resume():
	$AnimationPlayer.play()
