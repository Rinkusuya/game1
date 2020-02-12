extends CustomKin2DClass

class_name GameObject


# - call _gameObject_ready(affected_by_time : bool = true, affected_by_gravity : bool = true)
#	 on _ready() call
#
# if affected_by_time:
#	 set timeMultiplierChanged(), pause(), resume()


var _time_multiplier : float = 1
var _gravity_vect : Vector2 = Vector2.DOWN
var attackDamage = 0

# Ready
func _gameObject_ready(affected_by_time : bool = true, affected_by_gravity : bool = true):
	_customKin2DClass_ready()
	if affected_by_gravity:
		if not is_in_group("affected_by_gravity"):
			add_to_group("affected_by_gravity")
	if affected_by_time:
		if not is_in_group("affected_by_time"):
			add_to_group("affected_by_time")
		checkMethod("timeMultiplierChanged", true)
		checkMethod("pause", true)
		checkMethod("resume", true)
		checkMethod("hit", true)



# Gravity
func setGravity(gravity_vect : Vector2):
	
	#Check if erroneous call
	if not is_in_group("affected_by_gravity"):
		print("Erroneous [setGravity] call on " + str(name) + ": Not affected by gravity")
		return
	
	#Change _gravity_vect
	_gravity_vect = gravity_vect

func _floor():
	return Vector2(-_gravity_vect.normalized().x, -_gravity_vect.normalized().y)



# Time Manipulation

func setTimeMultiplier(new_time_mult : float):
	
	#Check if erroneous call
	if not is_in_group("affected_by_time"):
		print("Erroneous [setTimeMultiplier] call on " + str(name) + ": Not affected by time")
		return
	
	#Change Multiplier
	_time_multiplier = new_time_mult
	
	#Trigger _timeMultiplierChanged
	timeMultiplierChanged()
	
func timeMultiplierChanged():
	noObjectError("timeMultiplierChanged")


func pause():
	
	#Check if erroneous call
	if not is_in_group("affected_by_time"):
		print("Erroneous [pause] call on " + str(name) + ": Not affected by time")
		return
	
	noObjectError("pause")


func resume():
	
	#Check if erroneous call
	if not is_in_group("affected_by_time"):
		print("Erroneous [resume] call on " + str(name) + ": Not affected by time")
		return
	
	noObjectError("resume")


# Hittable
func hit(body : KinematicBody2D):
	noObjectError("hit")