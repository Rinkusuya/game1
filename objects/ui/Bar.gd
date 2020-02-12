extends UIBar

export(String) var Type = "None"

func _ready():
	_ui_bar_ready(10)
	set_bar_as(Type)

func set_bar_as(what : String):
	match what:
		"None":
			visible = false
			return
		"Life":
			$Bar.frame = 0
			for tick in $Ticks.get_children():
				tick.frame = 5
		"Fisherman":
			$Bar.frame = 1
			for tick in $Ticks.get_children():
				tick.frame = 6
		"Snowman":
			$Bar.frame = 2
			for tick in $Ticks.get_children():
				tick.frame = 7
		"Coalman":
			$Bar.frame = 3
			for tick in $Ticks.get_children():
				tick.frame = 8
		"Spaceman":
			$Bar.frame = 4
			for tick in $Ticks.get_children():
				tick.frame = 9
	visible = true