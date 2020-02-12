extends KinematicBody2D

class_name CustomKin2DClass

var level : Node2D

func _customKin2DClass_ready():
	level = firstInGroup("level_root")

func group(group):
	return get_tree().get_nodes_in_group(group)

func firstInGroup(group):
	var aux = group(group)
	if aux:
		return aux[0]
	return null

func checkMethod(method : String, onReady : bool = false):
	if not has_method(method):
		noObjectError(method, onReady)
		return false
	return true

func noObjectError(method : String, onReady : bool = false):
		print(("OnReady " if onReady else "") + "Error: Please set [" + method + "()] on object " + str(name) + "!")
	