extends Kin2D_TimeManipulable

var life = 100

var player

func _ready():
	_timeManipulable_ready()
	player = (get_tree().get_nodes_in_group("player"))[0]

func _process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if player:
		var vect = player.global_position-global_position
		var target_position = Vector2(vect.x*0.016, vect.y*0.04-6)
		$Eyes.position += delta*Vector2(0.15 *(1 if target_position.x>$Eyes.position.x else -1), 16 *(1 if target_position.y>$Eyes.position.y else -1))
		#print(delta*Vector2(0.15 *(1 if target_position.x>$Eyes.position.x else -1), 16 *(1 if target_position.y>$Eyes.position.y else -1)))
		if target_position.x - 0.1 < $Eyes.position.x and $Eyes.position.x < target_position.x + 0.1:
			$Eyes.position.x = target_position.x
		if target_position.y - 0.1 < $Eyes.position.y and $Eyes.position.y < target_position.y + 0.1:
			$Eyes.position.y = target_position.y

func pause():
	$AnimationPlayer.stop(false)

func resume():
	$AnimationPlayer.play()

func _time_multiplier_changed():
	$AnimationPlayer.playback_speed = _time_multiplier