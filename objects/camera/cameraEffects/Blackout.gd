extends Sprite

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