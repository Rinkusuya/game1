extends StaticBody2D

class_name EditorOnly

export (bool) var enabled = true

func _ready():
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = not enabled
	if has_node("CollisionShape2D2"):
		$CollisionShape2D.disabled = not enabled
	if has_node("CollisionPolygon2D"):
		$CollisionPolygon2D.disabled = not enabled
	if has_node("Sprite"):
		$Sprite.visible = false