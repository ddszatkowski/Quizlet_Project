extends Label

var showTimer = 0
var shown = false
func display():
	show()
	shown = true
	showTimer = 200


func _process(delta):
	if showTimer > 0:
		showTimer -= 1
	elif shown:
		hide()
		shown = false
		
