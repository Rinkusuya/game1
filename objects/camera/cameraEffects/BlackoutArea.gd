extends Area2D

export(String) var dir = "LR"
var level

func _ready():
	level = get_tree().get_nodes_in_group("level_root")[0]
	match dir:
		"LR": $SpriteLR.visible = true
		"UD": $SpriteUD.visible = true

func _on_BlackoutArea_body_entered(body):
	if body == level.player:
		level.camera.effects["Blackout"].start()


func _on_BlackoutArea_body_exited(body):
	if body == level.player:
		level.camera.effects["Blackout"].end()
