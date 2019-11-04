extends TextureButton


onready var buttons = [
get_parent().get_node("RedButton"), get_parent().get_node("BlueButton"),
get_parent().get_node("GreenButton"), get_parent().get_node("PurpleButton")]
var on = false
var color

func _ready():
	disabled = true

func pressed():
	on = not on
	if on:
		for button in buttons:
			button.set_pressed(false)
			button.on = false
		on = true
		set_pressed(true)
	else:
		set_pressed(false)
	get_parent().color = color