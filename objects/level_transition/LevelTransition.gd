extends EditorOnly

const TRANSITION_TIME = 1.0
const WAITTIME_ON_TRANSITION = 0.5

var player
var camera

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	camera = get_tree().get_nodes_in_group("game_camera")[0]
	$Sprite.visible = false

func activate():
	
	if player and camera:
		
		#Stop all things (stop enemies, players, objects, delete disposables, ...)
		for bullet in get_tree().get_nodes_in_group("projectile"):
			bullet.queue_free()
			bullet.remove_from_group("affected_by_time")
		
		for node in get_tree().get_nodes_in_group("affected_by_time"):
			if not node.is_in_group("game_camera"):
				node.pause()
		
		#Camera go fast
		camera.goFast()
		
		#Find transition direction
		var vect = global_position - camera.global_position
		#print("vect: " + str(vect))
		var dir
		if vect.x > 240:
			dir = Vector2.RIGHT
		elif vect.x < -240:
			dir = Vector2.LEFT
		elif vect.y > 160:
			dir = Vector2.DOWN
		elif vect.y < -160:
			dir = Vector2.UP
		
		#Wait some time
		var timer = Timer.new()
		timer.set_wait_time(WAITTIME_ON_TRANSITION)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		#Camera stop a bit
		camera.stopGoFast()
		camera.pause()
		
		#Start player animations
		player.get_node("AnimationPlayer").play()
		player.get_node("SmearPlayer").play()
		
		#Make transition
		var ticks = 0
		var TICK_TIME = 0.01
		var camera_vect = Vector2(dir.x*960, dir.y*640)*TICK_TIME/TRANSITION_TIME
		var player_vect = dir*dir*(dir*36 + global_position - player.global_position)*TICK_TIME/TRANSITION_TIME
		
		timer.set_wait_time(TICK_TIME)
		while TICK_TIME*ticks < TRANSITION_TIME:
			timer.start()
			ticks += 1
			camera.global_position += camera_vect
			player.global_position += player_vect
			yield(timer, "timeout")
		
		#Stop player animations
		player.get_node("AnimationPlayer").stop(false)
		player.get_node("SmearPlayer").stop(false)
		
		#Wait a little more
		timer.set_wait_time(WAITTIME_ON_TRANSITION)
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		
		#Resume things
		for node in get_tree().get_nodes_in_group("affected_by_time"):
			node.resume()