extends Node2D

var fiyaball = load("res://objects/enemies/FiyaBall.tscn")


func _on_Timer_timeout():
	add_child(fiyaball.instance())
