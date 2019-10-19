extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var x_bound
var y_bound
var target_pos
var top_speed = 5
var shoot_wait
var shoot_wait_max = 30
var charge_steps = [8, 6, 4, 2]

# Called when the node enters the scene tree for the first time.
func _ready():
	x_bound = ProjectSettings.get_setting("display/window/size/width")
	y_bound = ProjectSettings.get_setting("display/window/size/height")
	target_pos = [randf()*x_bound, randf()*y_bound]
	position.x = x_bound/2
	position.y = y_bound/2
	scale.x = .2
	scale.y = .2
	shoot_wait = charge_steps[0]
	$AnimatedSprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale.x < 1 or shoot_wait > charge_steps[0]:
		if scale.x < 1:
			scale.x += .03 * delta
			scale.y += .03 * delta
		else:
			shoot_wait -= delta
		velocity.x = (target_pos[0] - position.x) / 60
		velocity.y = (target_pos[1] - position.y) / 60
		
		if abs(velocity.x) < .5 and abs(velocity.y) < .5:
			while abs((target_pos[0] + target_pos[1]) - (position.x + position.y)) < 80:
				target_pos = [randf()*x_bound, randf()*y_bound]
				
		if velocity.x > top_speed:
			velocity.x = top_speed
		if velocity.x < -top_speed:
			velocity.x = -top_speed
		if velocity.y > top_speed:
			velocity.y = top_speed
		if velocity.y < -top_speed:
			velocity.y = -top_speed
			
		position += velocity * delta * 50
		position.x = clamp(position.x, 0, x_bound)
		position.y = clamp(position.y, 0, y_bound)
		$AnimatedSprite.flip_h = velocity.x > 0
		$AnimatedSprite.animation = "Dodging"
	else:
		if shoot_wait > charge_steps[1]:
			$AnimatedSprite.animation = "Charge0"
		elif shoot_wait > charge_steps[2]:
			$AnimatedSprite.animation = "Charge1"
		elif shoot_wait > charge_steps[3]:
			$AnimatedSprite.animation = "Charge2"
		elif shoot_wait > 0:
			$AnimatedSprite.animation = "Charge3"
		else:
			shootLaser()
			$AnimatedSprite.animation = "Charge0"
			shoot_wait = shoot_wait_max
		shoot_wait -= delta
		
func shootLaser():
	print("PEW!")
