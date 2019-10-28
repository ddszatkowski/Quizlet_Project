extends RigidBody2D

var angle
var end
var shown
var scaleVar
var forward
var positionVar

# Hide laser until it is fired
func _ready():
	positionVar = Vector2(0,0)
	scaleVar = Vector2(1,1)
	shown = false
	hide()

# Set position to start, angle sprite towards destination
func fire(startPos, endPos, goingForward):
	positionVar = startPos
	end = endPos
	forward = goingForward
	
	# Set laser starting size depending on direction
	if forward:
		scaleVar = Vector2(1,1)
	else:
		scaleVar = Vector2(2,2)
	
	# Angle laser towards destination
	angle = positionVar.angle_to_point(endPos)
	if not forward:
		angle += get_parent().get_parent().rotation
	$Laser_spr.rotation = angle
	
	# Stop hiding laser
	show()
	shown = true

func _process(delta):
	# Set position and scale to variable values (Fixes strange bug)
	position = positionVar
	scale = scaleVar
	
	# If laser is hidden, end here
	if not shown:
		return
	
	# Set velocity in destination direction
	var velocity = positionVar.direction_to(end) * delta * 1500
	positionVar.y += velocity.y
	positionVar.x += velocity.x
	
	# Grow or shrink laser based on direction, hide at point
	if forward:
		scaleVar.x += 8 * delta
		scaleVar.y = scaleVar.x
		if scale.x > 8:
			hide()
			shown = false
	else:
		scaleVar.x -= 4 * delta
		scaleVar.y = scaleVar.x
		if scale.x < .2:
			hide()
			shown = false
	
