extends AnimationPlayer

var _time_multiplier : float = 1
var f : float
var _animIsPlaying_saved = false

func _ready():
	add_to_group("affected_by_time")

func invincibility(seconds : float):
	f = seconds
	play("invincibility")

func _invincibilityTick():
	f -= 0.1
	if f < 0.1:
		stop()
		if get_parent().has_method("invincibilityEnd"):
			play("noInvincibility")
			get_parent().invincibilityEnd()

func setTimeMultiplier(new_time_mult : float):
	_time_multiplier = new_time_mult

func pause():
	if is_playing():
		_animIsPlaying_saved = true
		stop(false)
	else:
		_animIsPlaying_saved = false

func resume():
	if _animIsPlaying_saved:
		play()

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier