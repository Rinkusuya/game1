extends AudioStreamPlayer2D

func _ready():
	random_timer()

func random_timer():
	randomize()
	var rand_nb = rand_range(0.1, 4)
	$Timer.wait_time = rand_nb
	$Timer.start()

func _on_Timer_timeout():
	play()

func _on_AudioStreamPlayer2D_finished():
	random_timer()
