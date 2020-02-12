extends Control

var level
var running = false
var selection = "Default"
var dpad = Vector2.ZERO
var timeElapsedOnSelect = 0.0
const MAXGAPTIME = 0.05

func _ready():
	level = get_tree().get_nodes_in_group("level_root")[0]
	if level.playerHasPU_Fisherman:
		$PUWheel/Fisherman.visible = true
	if level.playerHasPU_Coalman:
		$PUWheel/Coalman.visible = true
	if level.playerHasPU_Snowman:
		$PUWheel/Snowman.visible = true
	if level.playerHasPU_Spaceman:
		$PUWheel/Spaceman.visible = true


var changed = false

func _process(delta):
	if running:
		var new_dpad = Vector2.ZERO
		if Input.is_action_just_released("gameSwitchWeapon"):
			stop()
			return
		if Input.is_action_pressed("gameUp"):
			new_dpad.y -= 1
		if Input.is_action_pressed("gameDown"):
			new_dpad.y += 1
		if Input.is_action_pressed("gameLeft"):
			new_dpad.x -= 1
		if Input.is_action_pressed("gameRight"):
			new_dpad.x += 1
		
		if new_dpad == dpad:
			timeElapsedOnSelect += delta
		else:
			timeElapsedOnSelect = 0.0
			changed = false
		
		if timeElapsedOnSelect >= MAXGAPTIME and not changed:
			changed = true
			match selection:
				"Default":
					$Default.visible = false
				"FishingLine":
					$Fisherman.visible = false
					$PUWheel/Fisherman/AnimationPlayer.play("noHover")
				"InfernoCoal":
					$Coalman.visible = false
					$PUWheel/Coalman/AnimationPlayer.play("noHover")
				"Snowball":
					$Snowman.visible = false
					$PUWheel/Snowman/AnimationPlayer.play("noHover")
				"TimeBomb":
					$Spaceman.visible = false
					$PUWheel/Spaceman/AnimationPlayer.play("noHover")
			
			
			if dpad.x == -1 and level.playerHasPU_Fisherman and selection != "FishingLine":
				selection = "FishingLine"
				$Fisherman.visible = true
				$PUWheel/Fisherman/AnimationPlayer.play("hover")
			elif dpad.x == 1 and level.playerHasPU_Coalman and selection != "InfernoCoal":
				selection = "InfernoCoal"
				$Coalman.visible = true
				$PUWheel/Coalman/AnimationPlayer.play("hover")
			elif dpad.y == -1 and level.playerHasPU_Snowman and selection != "Snowball":
				selection = "Snowball"
				$Snowman.visible = true
				$PUWheel/Snowman/AnimationPlayer.play("hover")
			elif dpad.y == 1 and level.playerHasPU_Spaceman and selection != "TimeBomb":
				selection = "TimeBomb"
				$Spaceman.visible = true
				$PUWheel/Spaceman/AnimationPlayer.play("hover")
			elif dpad == Vector2.ZERO:
				selection = "Default"
				$Default.visible = true
		
		dpad = new_dpad

func start():
	if not running:
		running = true
		level.pause()
		$PUWheel.visible = true
		$Default.visible = true
		$BG.visible = true

func stop():
	if running:
		var returnVal = selection
		running = false
		$BG.visible = false
		match selection:
			"Default":
				$Default.visible = false
			"FishingLine":
				$Fisherman.visible = false
				$PUWheel/Fisherman/AnimationPlayer.play("noHover")
			"InfernoCoal":
				$Coalman.visible = false
				$PUWheel/Coalman/AnimationPlayer.play("noHover")
			"Snowball":
				$Snowman.visible = false
				$PUWheel/Snowman/AnimationPlayer.play("noHover")
			"TimeBomb":
				$Spaceman.visible = false
				$PUWheel/Spaceman/AnimationPlayer.play("noHover")
		selection = "Default"
		level.resume()
		$PUWheel.visible = false
		return returnVal
	return null