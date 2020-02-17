extends Sprite

var _time_multiplier : float = 1
var _animationPlayerBool_saved = false
var _paused = false

func _ready():
	if not is_in_group("affected_by_time"):
		add_to_group("affected_by_time")

func start():
	if $AnimationPlayer.is_playing():
		var timePassed = $AnimationPlayer.current_animation_position
		$AnimationPlayer.play("start")
		$AnimationPlayer.seek(1.0-2.0*timePassed, true)
	else:
		$AnimationPlayer.play("start")

func end():
	if $AnimationPlayer.is_playing():
		var timePassed = $AnimationPlayer.current_animation_position
		$AnimationPlayer.play("end")
		$AnimationPlayer.seek(0.5-timePassed/2.0, true)
	else:
		$AnimationPlayer.play("end")

func setTimeMultiplier(new_time_mult : float):
	_time_multiplier = new_time_mult
	$AnimationPlayer.playback_speed = new_time_mult
	
func pause():
	if not _paused:
		_paused = true
		_animationPlayerBool_saved = $AnimationPlayer.is_playing()
		$AnimationPlayer.stop(false)

func resume():
	if  _paused:
		_paused = false
		if _animationPlayerBool_saved:
			$AnimationPlayer.play()
