extends RigidBody2D

var angle
var end
var scaleVar
var friend
var positionVar
var tot_dist
var org_pos
var dist_covered = 0
var speed = 2000
var direction
var start_scale
var end_scale
var enemy_collide = 2
var collision_type = "Laser"
var laser_color

func init(startPos, endPos, color, friendly):
	org_pos = startPos
	positionVar = startPos
	friend = friendly
	position = positionVar
	end = endPos
	
	tot_dist = (endPos - startPos).length()
	direction = (end - positionVar).normalized()
	
	# Set laser starting size depending on direction
	if friendly:
		start_scale = 5
		end_scale = 1
	else:
		start_scale = 1
		end_scale = 20

	scaleVar = Vector2(start_scale, start_scale)

	laser_color = color
	$Sprites.animation = color
		
	# Angle laser towards destination
	var y_diff = positionVar.y - endPos.y
	var x_diff = endPos.x - positionVar.x
	
	angle = atan(y_diff/x_diff)
	$Sprites.rotation = -angle

func _process(delta):
	scale = scaleVar
	
	# Set velocity in destination direction
	var velocity = direction * speed * delta
	positionVar += velocity
	
	dist_covered += speed * delta
	
	if friend:
		position = positionVar + Vector2(positionVar.x*.27, positionVar.y*.3) 
	else:
		position = positionVar
	
	if friend:
		scaleVar.x = (enemy_collide - start_scale) * dist_covered/tot_dist + start_scale
	else:
		scaleVar.x = (end_scale - start_scale) * dist_covered/tot_dist + start_scale
	scaleVar.y = scaleVar.x
	if (friend and scale.x < end_scale) or (not friend and scale.x > end_scale):
		get_parent().remove_child(self)
	
func _on_Area2D_area_entered(area):
	pass