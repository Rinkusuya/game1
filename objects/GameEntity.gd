extends GameObject

class_name GameEntity

var life : int

# Ready
func _gameEntity_ready(initLife : int = 0):
	_gameObject_ready()
	life = initLife
	checkMethod("attack", true)
	checkMethod("damage", true)
	checkMethod("hurt", true)

# Entity things
func attack(type : String = "Default"):
	noObjectError("attack")

func damage(from : PhysicsBody2D):
	noObjectError("damage")

func hurt(from : PhysicsBody2D):
	noObjectError("hurt")

func die():
	noObjectError("die")

func respawn():
	noObjectError("respawn")

