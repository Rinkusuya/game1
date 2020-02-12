extends Node2D

class_name UIBar

var _bar_max = 0
var _bar_current = 0

func _ui_bar_ready(bar_max : int):
	set_bar_max(bar_max)

func set_bar_max(bar_max : int):
	if _bar_max == 0 or bar_max < _bar_current:
		_bar_current = bar_max
	_bar_max = bar_max
	
func update_bar(new_perc : float):
	var new_val = int(new_perc*_bar_max)
	for tick in $Ticks.get_children():
		#print(tick.name)
		if int(tick.name) <= new_val:
			tick.visible = true
		else:
			tick.visible = false