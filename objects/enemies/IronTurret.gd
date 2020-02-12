extends Static2D_TimeManipulable

var object_enabled = true
var object_die = false
const ROTATION_MULTIPLIER = 3

var target
var target_in_range = false
var shootingVector = Vector2.ZERO

func _ready():
	_timeManipulable_ready()
	var aux = get_tree().get_nodes_in_group("player")
	if aux:
		target = aux[0]
	
func _process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if object_enabled:
		if target_in_range:
			shootingVector = target.global_position - global_position

func _physics_process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if object_die:
		queue_free()
	elif object_enabled:
		var angle = shootingVector.angle() + PI/2 - $Head.rotation
		$Head.rotation += delta*ROTATION_MULTIPLIER*angle if abs(angle) > 0.01 else 0
		$DV_Turret.set_vector(global_position)
		if target:
			$DV_Target.set_vector(target.global_position)
	
	#if 160 < shootingVector.length() < 480:
	#	$PlayerDetectionRange/Sprite.modulate.a = -(320-shootingVector)*(320-shootingVector)+
	

func _detection_range_entered(area):
	if target == area:
		target_in_range = true

func _detection_range_exited(area):
	if target == area:
		target_in_range = false

func timeMultiplierChanged():
	pass

func pause():
	object_enabled = false

func resume():
	object_enabled = true