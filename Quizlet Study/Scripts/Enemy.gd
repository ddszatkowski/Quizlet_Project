extends Node2D

var velocity = Vector2()
var x_bound
var y_bound
var target_pos
var top_speed = 5

# Once ship is close enough, counts down to 0, then fires lasers
var shoot_wait
var shoot_wait_max = 10

# Time increments within shoot_wait at which animation changes
var charge_steps = [4, 3, 2, 1]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Bounds of movement, will be space window later
	x_bound = ProjectSettings.get_setting("display/window/size/width")
	y_bound = ProjectSettings.get_setting("display/window/size/height")
	
	# Current and target positions
	position = Vector2(randf()*x_bound, randf()*y_bound)
	generate_destination()
	
	# Start small, move closer to screen
	scale.x = .2
	scale.y = .2
	
	# First shoot is immediately after reaching ship
	shoot_wait = charge_steps[0]

# Find location within bounds that is at least 80 pixels from current position
func generate_destination():
	target_pos = Vector2(randf()*x_bound, randf()*y_bound)
	while (target_pos - position).length() < 80:
		target_pos = Vector2(randf()*x_bound, randf()*y_bound)
	

func _process(delta):
	# If just fired lasers, wait
	if $Laser1.shown:
		return
	
	# If still far away, or not yet charging laser
	if scale.x < 1 or shoot_wait > charge_steps[0]:
		# Get closer, or prepare to charge
		if scale.x < 1:
			scale.x += .06 * delta
			scale.y += .06 * delta
		else:
			shoot_wait -= delta
			
		# Get velocity based on distance
		velocity.x = (target_pos[0] - position.x) / 20
		velocity.y = (target_pos[1] - position.y) / 20
		if velocity.x > top_speed:
			velocity.x = top_speed
		if velocity.x < -top_speed:
			velocity.x = -top_speed
		if velocity.y > top_speed:
			velocity.y = top_speed
		if velocity.y < -top_speed:
			velocity.y = -top_speed
			
		# Move within bounds
		position += velocity * delta * 50
		position.x = clamp(position.x, 0, x_bound)
		position.y = clamp(position.y, 0, y_bound)
		
		# If close to destination, retarget
		if abs(velocity.x) < .5 and abs(velocity.y) < .5:
			while (target_pos - position).length() < 80:
				target_pos = Vector2(randf()*x_bound, randf()*y_bound)
		
		# Flip sprite based on direction
		$AnimatedSprite.flip_h = velocity.x > 0
		$AnimatedSprite.animation = "Dodging"
		
	else:
		# Change sprite based on level of charge
		if shoot_wait > charge_steps[1]:
			$AnimatedSprite.animation = "Charge0"
		elif shoot_wait > charge_steps[2]:
			$AnimatedSprite.animation = "Charge1"
		elif shoot_wait > charge_steps[3]:
			$AnimatedSprite.animation = "Charge2"
		elif shoot_wait > 0:
			$AnimatedSprite.animation = "Charge3"
		# If finished, shoot lasers
		else:
			shootLaser()
			$AnimatedSprite.animation = "Charge0"
			shoot_wait = shoot_wait_max
		shoot_wait -= delta
		
# Spawn lasers at ship cannons, move them to absolute coordinates at bottom of screen
func shootLaser():
	$Laser1.fire(Vector2(-30, 20), Vector2(0, 2*y_bound) - get_position(), true)
	$Laser2.fire(Vector2(30, 20), Vector2(x_bound, 2*y_bound) - get_position(), true)
