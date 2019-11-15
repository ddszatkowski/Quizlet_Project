extends TextureButton


onready var buttons = [
get_parent().get_node("RedButton"), get_parent().get_node("BlueButton"),
get_parent().get_node("GreenButton"), get_parent().get_node("PurpleButton")]
var on = false
var rowSizeMax = 400
var ySizeMax = 80
var color
var font

func _ready():
	font = get_children()[0].get_font("")
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
	
func set_display(msg):
	if msg.length() < 30:
		font.size = 20
	else:
		var size = 19
		var rows = msg.length() / int(rowSizeMax / size)
		if msg.length() / int(rowSizeMax / size) != 0:
			rows += 1
		while size * rows > ySizeMax:
			size -= 1
			rows = msg.length() / int(rowSizeMax / size)
			if msg.length() / int(rowSizeMax / size) != 0:
				rows += 1
			var temp = size * rows
		font.size = size
		
		var pos = int(rowSizeMax / font.size)
		while pos < msg.length():
			var strStart = msg.substr(0, pos)
			var strEnd = msg.substr(pos, msg.length() - pos)
			msg = strStart + '\n' + strEnd
			pos = int(rowSizeMax / font.size) + pos + 1
	get_children()[0].text = msg