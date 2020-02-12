extends UIBar

export(String) var Type = "None"

func _ready():
	_ui_bar_ready(20)
	set_bar_as(Type)

func set_bar_as(what : String):
	match what:
		"None":
			visible = false
			return
		"Crocky":
			for tick in $Ticks.get_children():
				tick.frame = 1
		"Fisherman":
			for tick in $Ticks.get_children():
				tick.frame = 2
		"GuardianSnowman":
			for tick in $Ticks.get_children():
				tick.frame = 3
		"Snowman":
			for tick in $Ticks.get_children():
				tick.frame = 4
		"GuardianCoalman":
			for tick in $Ticks.get_children():
				tick.frame = 5
		"Coalman":
			for tick in $Ticks.get_children():
				tick.frame = 6
		"GuardianSpaceman":
			for tick in $Ticks.get_children():
				tick.frame = 7
		"Spaceman":
			for tick in $Ticks.get_children():
				tick.frame = 8
		"You":
			for tick in $Ticks.get_children():
				tick.frame = 9
	visible = true