extends VisibilityNotifier2D

var test = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Laser_visibility_changed():
	test = not test
	pass # Replace with function bdy.
