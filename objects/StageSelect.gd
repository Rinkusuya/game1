extends Node2D

var fisherman = true
var snowman = true
var coalman = true
var spaceman = true

var currentSelection = "None"
var selected = "None"
var i = 6

func _ready():
	
	if fisherman:
		$FishermanBG/AnimationPlayer.play("available")
	else:
		$FishermanBG/AnimationPlayer.play("unavailable")
	
	if snowman:
		$SnowmanBG/AnimationPlayer.play("available")
	else:
		$SnowmanBG/AnimationPlayer.play("unavailable")
	
	if coalman:
		$CoalmanBG/AnimationPlayer.play("available")
	else:
		$CoalmanBG/AnimationPlayer.play("unavailable")
	
	if spaceman:
		$SpacemanBG/AnimationPlayer.play("available")
	else:
		$SpacemanBG/AnimationPlayer.play("unavailable")



func _hover(who):
	if selected != "None":
		return
	
	#$AudioStreamPlayer_FX.stream = "res://assets/audio/selected.wav"
	$AudioStreamPlayer_FX.play()
	
	match who:
		"Fisherman":
			if fisherman:
				$FishermanBG/AnimationPlayer.play("hover")
				_hoverEnd("Snowman")
				_hoverEnd("Coalman")
				_hoverEnd("Spaceman")
				currentSelection = who
		"Snowman":
			if snowman:
				$SnowmanBG/AnimationPlayer.play("hover")
				_hoverEnd("Fisherman")
				_hoverEnd("Coalman")
				_hoverEnd("Spaceman")
				currentSelection = who
		"Coalman":
			if coalman:
				$CoalmanBG/AnimationPlayer.play("hover")
				_hoverEnd("Fisherman")
				_hoverEnd("Snowman")
				_hoverEnd("Spaceman")
				currentSelection = who
		"Spaceman":
			if spaceman:
				$SpacemanBG/AnimationPlayer.play("hover")
				_hoverEnd("Fisherman")
				_hoverEnd("Snowman")
				_hoverEnd("Coalman")
				currentSelection = who
		"None":
			var i = currentSelection
			_hoverEnd("Fisherman")
			_hoverEnd("Snowman")
			_hoverEnd("Coalman")
			_hoverEnd("Spaceman")
			currentSelection = i


func _hoverEnd(who):
	if selected != "None":
		return
	
	currentSelection = "None"
	
	match who:
		"Fisherman":
			if fisherman:
				$FishermanBG/AnimationPlayer.play("available")
			else:
				$FishermanBG/AnimationPlayer.play("unavailable")
		"Snowman":
			if snowman:
				$SnowmanBG/AnimationPlayer.play("available")
			else:
				$SnowmanBG/AnimationPlayer.play("unavailable")
		"Coalman":
			if coalman:
				$CoalmanBG/AnimationPlayer.play("available")
			else:
				$CoalmanBG/AnimationPlayer.play("unavailable")
		"Spaceman":
			if spaceman:
				$SpacemanBG/AnimationPlayer.play("available")
			else:
				$SpacemanBG/AnimationPlayer.play("unavailable")

func _buttonPressed(who):
	if selected != "None":
		return
	
	$AudioStreamPlayer_Song.stop()
	$AudioStreamPlayer_FX.stream = load("res://assets/audio/stageSelected.wav")
	$AudioStreamPlayer_FX.play()
	
	selected = who
	match who:
		"Fisherman":
			$FishermanBG/AnimationPlayer.play("selected")
		"Snowman":
			$SnowmanBG/AnimationPlayer.play("selected")
		"Coalman":
			$CoalmanBG/AnimationPlayer.play("selected")
		"Spaceman":
			$SpacemanBG/AnimationPlayer.play("selected")

func _selectedBlink():
	i -= 1
	if i==0:
		match selected:
			"Fisherman":
				get_tree().change_scene("res://objects/SelectedFisherman.tscn")
			"Snowman":
				get_tree().change_scene("res://objects/SelectedSnowman.tscn")
			"Coalman":
				get_tree().change_scene("res://objects/SelectedCoalman.tscn")
			"Spaceman":
				get_tree().change_scene("res://objects/SelectedSpaceman.tscn")

func _process(delta):
	if Input.is_action_just_pressed("gameUp"):
		if currentSelection != "Snowman":
			_hover("Snowman")
	if Input.is_action_just_pressed("gameDown"):
		if currentSelection != "Spaceman":
			_hover("Spaceman")
	if Input.is_action_just_pressed("gameLeft"):
		if currentSelection != "Fisherman":
			_hover("Fisherman")
	if Input.is_action_just_pressed("gameRight"):
		if currentSelection != "Coalman":
			_hover("Coalman")
	if Input.is_action_just_pressed("gameStart"):
		_hover("None")
		_buttonPressed(currentSelection)
