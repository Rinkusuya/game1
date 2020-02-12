extends EditorOnly

var player
var attackDamage

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	attackDamage = player.MAXLIFE*100