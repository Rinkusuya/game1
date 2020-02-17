extends Node2D

var camera : KinematicBody2D
var player : KinematicBody2D
var dispensableContainer : Node2D
var enemyContainer : Node2D

var playerHasPU_Fisherman = true
var playerHasPU_Snowman = true
var playerHasPU_Coalman = true
var playerHasPU_Spaceman = true

var lives

func _ready():
	if not is_in_group("level_root"):
		add_to_group("level_root")
	var aux = get_tree().get_nodes_in_group("game_camera")
	if aux:
		setCamera(aux[0])
	aux = get_tree().get_nodes_in_group("player")
	if aux:
		setPlayer(aux[0])
	aux = get_tree().get_nodes_in_group("dispensable_container")
	if aux:
		dispensableContainer = aux[0]
	aux = get_tree().get_nodes_in_group("enemy_container")
	if aux:
		enemyContainer = aux[0]
	setLives(3)

func setCamera(new_camera : KinematicBody2D):
	camera = new_camera
	
func setPlayer(new_player : KinematicBody2D):
	player = new_player

func setLives(num):
	lives = num
	camera.get_node("UI").get_node("LivesCounter").get_node("Lives").set_text(str(lives))

func setGravity(gravity_vect : Vector2):
	for node in get_tree().get_nodes_in_group("affected_by_gravity"):
		node.setGravity(gravity_vect)

func setTimeMultiplier(new_time_mult : float):
	for node in get_tree().get_nodes_in_group("affected_by_time"):
		node.setTimeMultiplier(new_time_mult)

func pause():
	for node in get_tree().get_nodes_in_group("affected_by_time"):
		node.pause()

func resume():
	for node in get_tree().get_nodes_in_group("affected_by_time"):
		node.resume()