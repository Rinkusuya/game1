extends KinematicBody2D

class_name Kin2D_TimeManipulable

var _time_multiplier : float = 1

func _timeManipulable_ready():
	if not is_in_group("affected_by_time"):
		add_to_group("affected_by_time")

func setTimeMultiplier(new_time_mult : float):

	_time_multiplier = new_time_mult
	
	timeMultiplierChanged()


func timeMultiplierChanged():
	print("Error: Please set [timeMultiplierChanged()] on object " + str(name) + "!")