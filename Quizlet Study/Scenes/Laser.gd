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
	
	scaleVar = Vector2(1,1)
	angle = positionVar.angle_to_point(endPos)
	$Laser_spr.rotation = angle
	
	show()
	shown = true

func _process(delta):
	position = positionVar
	scale = scaleVar
	if not shown:
		return
	var velocity = positionVar.direction_to(end) * delta * 1500
	positionVar.y += velocity.y
	positionVar.x += velocity.x
	if forward:
		scaleVar.x += 8 * delta
		scaleVar.y = scaleVar.x
		if scale.x > 8:
			hide()
			shown = false
	
