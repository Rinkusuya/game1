extends Kin2D_TimeManipulable

const CAMERA_SPEED_MULTIPLIER = 100

var respawn_camerapos = Vector2.ZERO
var auto_camera = true
var target
var fast = false

var effects = {
	"Blackout" :		null,
	"Earthquake" :		null
}
var lifebar
var weaponbar
var bossbar
var PUSelection

func _ready():
	_timeManipulable_ready()
	var aux = get_tree().get_nodes_in_group("player")
	if aux:
		target = aux[0]
	else:
		print("Error: No player found! " + str(self))
	respawn_camerapos = global_position
	lifebar = $UI/LifeBar
	weaponbar = $UI/WeaponBar
	bossbar = $UI/BossHPBar
	PUSelection = $UI/PUSelectionOverlay
	effects["Blackout"] = $Effects/Blackout
	effects["Earthquake"] = $Effects/Earthquake

func _physics_process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if target and auto_camera:
		var vect = target.global_position-global_position
		var modvect = vect.length()
		var sqmodvect = pow(modvect, 2)
		
		if vect.length() > 320:
			vect = vect.normalized()*(sqmodvect*5/512 - modvect*21/4 + 1000)
		move_and_slide(vect*CAMERA_SPEED_MULTIPLIER*delta*(4 if fast else 1))

func timeMultiplierChanged():
	pass

func pause():
	auto_camera = false

func resume():
	auto_camera = true

func goFast():
	fast = true

func stopGoFast():
	fast = false

func hideUI():
	$UI.visible = false
	
func showUI():
	$UI.visible = true