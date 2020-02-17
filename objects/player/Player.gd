extends GameEntity

var pellet = preload("res://objects//weapons//Pellet.tscn")

#Checks
var ladder = []
var soundEffects = {
		"landing2":		preload("res://assets/audio/landing2.wav"),
		"healed":		preload("res://assets/audio/healed.wav")}
var physicsFreeze = false
var controlLock = false
var jump = 0
var canJump = 0
var attack_input = false
var dpad = Vector2.ZERO
export(String) var lastLR = "R"
var anim_justLanded = false
var anim_justJumped = false
var anim_landingvel = Vector2.ZERO
var anim_attack = false
var wasOnAir = false
var jumpWasPressed = false
var attackWasPressed = false
var respawn_LR
var respawn_pos = Vector2.ZERO
var died = false
var is_dead = false
var isInvincible = false
var jumpHold = false
var hurtingAnim = false
var overLadder = false
var grabbingLadder = false
var canRegrab = false
var attacking = false

var weapontimer = 0

#Constants
const BASEACCEL = 320*10
const BASEDEACCEL = 320*5
const GRAVACCEL = 320*10
const JUMPFORCE = 320*3.7
const MAXGROUNDVEL = 240
const JUMPTIMEGAP_PRE = 0.15
const JUMPTIMEGAP_POST = 0.05
const MAXLIFE = 200
const STARTINGLIFE = 200
const CLIMBSPEED = 192

const MAXWEAPONTIMER = 0.1

var vel = Vector2.ZERO

func _ready():
	_gameEntity_ready(STARTINGLIFE)
	
	life = STARTINGLIFE
	respawn_LR = lastLR
	respawn_pos = global_position
	
	level.setTimeMultiplier(1)
	#setTimeMultiplier(1)

func _process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	inputHandler()
	if not _paused:
		animationUpdate()
		if weapontimer>0:
			weapontimer-=delta
		if attack_input:
			attack()
	
func _physics_process(delta):
	var trueDelta = delta
	delta = delta*_time_multiplier
	
	if not physicsFreeze:
		var accel = Vector2(0, 0)
		var vel_before_collision
		
		if hurtingAnim:
			pass
		elif grabbingLadder:
			if is_on_floor():
				grabbingLadder = false
				canRegrab = false
			vel = Vector2(0, dpad.y*CLIMBSPEED*_time_multiplier if not attacking else 0)
		elif is_on_floor():
			accel.x = (BASEACCEL*dpad.x + BASEDEACCEL*(1 if vel.x<0 else -1 if vel.x>0 else 0))*delta
			jumpHold = false
			if canJump != JUMPTIMEGAP_POST:
				canJump = JUMPTIMEGAP_POST
			if jump > 0 and canJump > 0:
				vel.y = -JUMPFORCE*_time_multiplier
				anim_justJumped = true
				jump = 0
				canJump = 0
				jumpHold = true
			elif wasOnAir:
				anim_justLanded = true
			wasOnAir = false
		else:
			accel.x = (BASEACCEL*dpad.x + BASEDEACCEL*(1 if vel.x<0 else -1 if vel.x>0 else 0))*delta
			jump -= delta if jump > 0 else 0
			canJump -= delta if canJump > 0 else 0
			if vel.y > 0:
				jumpHold = true
			if jump > 0 and canJump > 0:
				vel.y = -JUMPFORCE*_time_multiplier
				anim_justJumped = true
				jump = 0
				canJump = 0
				jumpHold = true
			anim_landingvel = vel
			wasOnAir = true
			
		accel.y = GRAVACCEL*delta*(1.0 if jumpHold else 4.0)
		accel = accel*_time_multiplier
		vel += accel*(1.0 if not hurtingAnim else 0.2) if not grabbingLadder else Vector2.ZERO
		
		#Float python thingie
		if dpad.x==0 and abs(vel.x) < delta*BASEDEACCEL*2:
			vel.x = 0
		
		#Max Velocity
		if vel.x>MAXGROUNDVEL*_time_multiplier:
			vel.x=MAXGROUNDVEL*_time_multiplier
		elif vel.x<-MAXGROUNDVEL*_time_multiplier:
			vel.x=-MAXGROUNDVEL*_time_multiplier
		if vel.y>1020*_time_multiplier:
			vel.y = 1020*_time_multiplier
		
		vel_before_collision = vel
		vel = move_and_slide(vel, Vector2.UP)
		
		#print(vel)
		for i_collision in range(0, get_slide_count()):
			var collision = get_slide_collision(i_collision)
			if collision:
				var obj : Node2D = collision.collider
				
				#print(obj)
				#print(obj.name)
				#print(obj.get_collision_layer_bit(5))
				
				#Instadeath
				if obj.get_collision_layer_bit(1):
					move_and_slide(Vector2.ZERO, Vector2.ZERO)
					damage(obj)
				
				#Enemy Hitbox
				if obj.get_collision_layer_bit(5):
					move_and_slide(Vector2.ZERO, Vector2.ZERO)
					if not isInvincible:
						damage(obj)
						obj.hit(self)
				
				#Level Transition
				if obj.get_collision_layer_bit(11):
					move_and_slide(Vector2.ZERO, Vector2.ZERO)
					$SmearPlayer.stop()
					obj.activate()
				


func inputHandler():
	
	#Movement
	var mov = Vector2.ZERO
	var jum = false
	var atk = false
	
	if not controlLock and not _paused:
		if Input.is_action_pressed("gameUp"):
			mov.y -= 1
		if Input.is_action_pressed("gameDown"):
			mov.y += 1
			set_collision_mask_bit(6, false)
		elif not get_collision_mask_bit(6):
			set_collision_mask_bit(6, true)
		if Input.is_action_pressed("gameLeft"):
			mov.x -= 1
		if Input.is_action_pressed("gameRight"):
			mov.x += 1
		if Input.is_action_pressed("gameJump"):
			jum = true
		if Input.is_action_just_pressed("gameJump"):
			if grabbingLadder:
				grabbingLadder = false
				vel.y-=JUMPFORCE*_time_multiplier
			canRegrab = false
		if Input.is_action_pressed("gameShoot"):
			atk = true
		if Input.is_action_just_pressed("gameUp") or Input.is_action_just_pressed("gameDown"):
			canRegrab = true
		if Input.is_action_just_pressed("gameSwitchWeapon"):
			level.camera.PUSelection.start()
			#level.camera.effects["Earthquake"].play("strong")
		if mov.y != 0 and overLadder and not grabbingLadder and canRegrab:
			grabbingLadder = true
			global_position.x = ladder.back().global_position.x
			move_and_slide(Vector2.ZERO, Vector2.ZERO)
			canJump = 0
		
		
	if Input.is_action_just_pressed("gameDebug"):
		var tmult = 1/_time_multiplier
		level.setTimeMultiplier(tmult)
		
	dpad = mov
	
	if not jumpWasPressed and jum:
		jumpWasPressed = true
		jump = JUMPTIMEGAP_PRE
	elif not jum:
		jumpWasPressed = false
		jumpHold = false
	
	if not attackWasPressed and atk:
		attackWasPressed = true
		attack_input = true
	elif not atk:
		attackWasPressed = false
		
	if mov.x<0:
		lastLR = "L"
	elif mov.x>0:
		lastLR = "R"
		
func animationUpdate():
	
	match $AnimationPlayer.current_animation:
		"hurt":
			if $AnimationPlayer.is_playing():
				return
	
	if died:
		$AnimationPlayer.play("die")
		died = false
	elif grabbingLadder:
		var moving = dpad.y!=0
		var climbAnim = $AnimationPlayer.current_animation == "climb6" or $AnimationPlayer.current_animation == "climb7"
		var animIsPlaying = $AnimationPlayer.is_playing()
		if anim_attack:
			anim_attack = false
			$AnimationPlayer.stop()
			match $Sprite/Body.frame:
				4, 6:
					$AnimationPlayer.play("climbAttack68")
				_:
					$AnimationPlayer.play("climbAttack79")
		elif not attacking and moving and not climbAnim:
			if $Sprite/Body.frame == 4:
				$AnimationPlayer.play("climb7")
			else:
				$AnimationPlayer.play("climb6")
		elif not attacking and not moving and climbAnim and animIsPlaying:
			$AnimationPlayer.stop()
		else:
			match $Sprite/Body.frame:
				4, 5, 6, 7:
					pass
				_:
					$Sprite/Body.frame = 4
		
	elif is_on_floor() and not is_dead:
		if vel.x!=0:
			$AnimationPlayer.play("walk")
		elif anim_attack:
			anim_attack = false
			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack")
		elif $AnimationPlayer.current_animation != "attack":
			$AnimationPlayer.play("idle")
			
		
		if anim_justLanded:
			$SmearPlayer.stop()
			if abs(anim_landingvel.y) > 1600:
				$SmearPlayer.play("mediumLandingSmearing")
			else:
				$SmearPlayer.play("smallLandingSmearing")
			$AudioStreamPlayer.stream = soundEffects["landing2"]
			$AudioStreamPlayer.playing = true
			anim_justLanded = false
	elif not is_dead:
		$AnimationPlayer.play("jump")
		
		if anim_justJumped:
			$SmearPlayer.stop()
			$SmearPlayer.play("jumpSmearing")
			anim_justJumped = false
	
	if lastLR == "L":
		$Sprite/Body.flip_h=true
	else:
		$Sprite/Body.flip_h=false

func attackEnd():
	attacking = false

func timeMultiplierChanged():
	$AnimationPlayer.playback_speed = _time_multiplier
	$SmearPlayer.playback_speed = _time_multiplier
	$InvincibilityPlayer.playback_speed = _time_multiplier
	vel = vel*pow(_time_multiplier, 2)

#Pause Resume functions
var _paused = false
var _controlLock_saved
var _physicsFreeze_saved
var _animationPlayerBool_saved
var _smearPlayerBool_saved

func pause():
	if not _paused:
		_paused = true
		_controlLock_saved = controlLock
		_physicsFreeze_saved = physicsFreeze
		_animationPlayerBool_saved = $AnimationPlayer.is_playing()
		_smearPlayerBool_saved = $SmearPlayer.is_playing()
		controlLock = true
		physicsFreeze = true
		$AnimationPlayer.stop(false)
		$SmearPlayer.stop(false)

func resume():
	if  _paused:
		_paused = false
		controlLock = _controlLock_saved
		physicsFreeze = _physicsFreeze_saved
		if _animationPlayerBool_saved:
			$AnimationPlayer.play()
		if _smearPlayerBool_saved:
			$SmearPlayer.play()

# Basic Game Events
func die():
	controlLock = true
	physicsFreeze = true
	died = true
	is_dead = true
	invincibility(4)

func respawn():
	level.setLives(level.lives - 1)
	if level.lives <= 0:
		pass # Game Over
	life = STARTINGLIFE
	level.camera.lifebar.update_bar(float(STARTINGLIFE)/float(MAXLIFE))
	lastLR = respawn_LR
	global_position = respawn_pos
	level.camera.global_position = level.camera.respawn_camerapos
	vel = Vector2.ZERO
	controlLock = false
	physicsFreeze = false
	died = false
	is_dead = false
	#print("respawn!")

func heal(lifeGained : int):
	if life >= MAXLIFE:
		life = MAXLIFE
	else:
		level.pause()
		for tick in range(life, life+lifeGained, 20):
			$AudioStreamPlayer.stream = soundEffects["healed"]
			$AudioStreamPlayer.play()
			life += 20
			if life > MAXLIFE:
				life = MAXLIFE
			level.camera.lifebar.update_bar(float(life)/float(MAXLIFE))
			yield($AudioStreamPlayer, "finished")
			if life == MAXLIFE:
				break
		level.resume()

func refill(type : String):
	match type:
		"Big":
			pass
		"Small":
			pass

func damage(from : PhysicsBody2D):
	life -= from.attackDamage
	level.camera.lifebar.update_bar(float(life)/float(MAXLIFE))
	if life<=0:
		die()
	else:
		hurt(from)

func hurt(from : PhysicsBody2D):
	var colVect = from.global_position-global_position
	invincibility(2)
	uncontrollable()
	vel.x = 96 if colVect.x < 0 else -96
	vel.y = 0
	hurtingAnim = true
	$AnimationPlayer.play("hurt")
	grabbingLadder = false # Invincibility 3, hurt animation, can't control until end of hurt animation

func hurtEnd():
	hurtingAnim = false
	uncontrollableEnd()

func attack(type : String = "Default"):
	if weapontimer<=0 and level.dispensableContainer:
		weapontimer=MAXWEAPONTIMER
		
		var pelletInst = pellet.instance()
		if lastLR=="L":
			pelletInst.shoot(position + Vector2(-32, 8), Vector2.LEFT, _time_multiplier)
		else:
			pelletInst.shoot(position + Vector2(32, 8), Vector2.RIGHT, _time_multiplier)
		level.dispensableContainer.add_child(pelletInst)
		
		$AttackPlayer.play("attack")
		
		anim_attack = true
		if grabbingLadder:
			attacking = true
		
	attack_input = false

func hit(from : KinematicBody2D):
	if not isInvincible:
		damage(from)

func invincibility(seconds : float):
	isInvincible = true
	set_collision_mask_bit(5, false)
	$InvincibilityPlayer.invincibility(seconds)

func invincibilityEnd():
	isInvincible = false
	set_collision_mask_bit(5, true)

func uncontrollable():
	controlLock = true

func uncontrollableEnd():
	controlLock = false

func extraLife():
	level.setLives(level.lives + 1)

# Stairs
func stairEnter(stair):
	ladder.append(stair)
	if not overLadder:
		overLadder = true

func stairExit(stair):
	ladder.remove(ladder.find(stair))
	if ladder.size() == 0:
		overLadder = false
		grabbingLadder = false

