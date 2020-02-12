extends Area2D

export(String) var Type
var level

func _ready():
	level = get_tree().get_nodes_in_group("level_root")[0]
	match Type:
		"Iron":
			$Sprite.frame = 1
		"Ice":
			$Sprite.frame = 2


func _on_HandLadder_body_entered(body):
	if level and level.player == body:
		level.player.stairEnter(self)

func _on_HandLadder_body_exited(body):
	if level and level.player == body:
		level.player.stairExit(self)
