extends Area2D

var level
var _time_multiplier : float = 1
var _paused = false

export(String) var Enemy = "None"
var inRange = 0

var entity
var instance
var spawnPos

func _ready():
	level = get_tree().get_nodes_in_group("level_root")[0]
	if not is_in_group("affected_by_time"):
		add_to_group("affected_by_time")
	match Enemy:
		"None":
			return
		"SpaceOozeBall":
			entity = load("res://objects/enemies/SpaceOozeBall.tscn")
			spawnPos = funcref(self, "_spaceoozeball_pos")

func _physics_process(delta):
	if inRange > 0:
		if not instance and not _paused:
			if not entity or not spawnPos:
				print("Error: Enemy type not found on SpawningArea [" + str(name) + "]")
			instance = entity.instance()
			instance.global_position = spawnPos.call_func()
			instance.connect("exitedScreen", self, "_onEntityExitedScreen")
			instance.setTimeMultiplier(_time_multiplier)
			level.enemyContainer.add_child(instance)

func _on_SpawningArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body == level.player:
		inRange += 1
		$RayCast2D.enabled = true

func _on_SpawningArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body == level.player:
		inRange -= 1
		if inRange == 0:
			$RayCast2D.enabled = false

func _onEntityExitedScreen():
	instance.queue_free()
	instance = null

# All Pos Funcs
func _spaceoozeball_pos():
	$RayCast2D.global_position = level.player.global_position
	$RayCast2D.cast_to = Vector2(4800, -3200)
	return $RayCast2D.get_collision_point()

func setTimeMultiplier(new_time_mult : float):
	_time_multiplier = new_time_mult
	
func pause():
	if not _paused:
		_paused = true

func resume():
	if  _paused:
		_paused = false
	