extends RigidBody2D

var velocity = Vector2()

# Bounds of Movement
var x_max = ProjectSettings.get_setting("display/window/size/width") * 9/8
var y_max = ProjectSettings.get_setting("display/window/size/height")
var x_min = x_max / 4
var y_min = y_max / 2

var target_pos
var top_speed = 5
var scaleVar = Vector2(.2,.2)
var question
signal selected(id)

# Time increments within shoot_wait at which animation changes
var charge_steps = [4, 3, 2, 1]

# Once ship is close enough, counts down to 0, then fires lasers
var shoot_wait = charge_steps[0]
var shoot_wait_max = 10

# Should be called when enemy is spawned. 
# Stores question and connects signals to all other enemies
func init(enemies, q):
	question = q
	for enemy in enemies:
		enemy.connect("selected", self, "_on_Enemy_selected")
		connect("selected", enemy, "_on_Enemy_selected")
	enemies.append(self)
	return enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Current and target positions
	position = Vector2(randf()*(x_max-x_min) + x_min, randf()*(y_max-y_min) + y_min)
	generate_destination()
	
	# First shoot is immediately after reaching ship
	shoot_wait = charge_steps[0]
	
	var temp = get_parent().get_child(6)
	temp = temp.get_child(0)
	temp.connect("selected", self, "_on_Enemy_selected")
	
	$Selection.hide()

# Find location within bounds that is at least 80 pixels from current position
func generate_destination():
	target_pos = Vector2(randf()*(x_max-x_min) + x_min, randf()*(y_max-y_min) + y_min)
	while (target_pos - position).length() < 80:
		target_pos = Vector2(randf()*(x_max-x_min) + x_min, randf()*(y_max-y_min) + y_min)
	

func _process(delta):
	# Set scale of enemy to variable
	set_scale(scaleVar)
	
	# Keep Selection scale from inheriting from enemy
	$Selection.scale.x = 2/(scale.x)
	$Selection.scale.y = 2/(scale.y)
	
	# If just fired lasers, wait
	if $Laser1.shown:
		return
	
	# If still far away, or not yet charging laser
	if scaleVar.x < 1 or shoot_wait > charge_steps[0]:
		# Get closer, or prepare to charge
		if scaleVar.x < 1:
			scaleVar.x += .06 * delta
			scaleVar.y += .06 * delta
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
		position.x = clamp(position.x, x_min, x_max)
		position.y = clamp(position.y, y_min, y_max)
		
		# If close to destination, retarget
		if abs(velocity.x) < .5 and abs(velocity.y) < .5:
			generate_destination()
		
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
	$Laser1.fire(Vector2(-30, 20), Vector2(x_min, 2*y_max), true)
	$Laser2.fire(Vector2(30, 20), Vector2(x_max, 2*y_max), true)

# If enemy is clicked on, send selected signal to all other enemies and screen
func _on_Enemy_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("Click"):
		emit_signal("selected")
		$Selection.show()

# If received selected signal from another enemy, hide selection cursor
func _on_Enemy_selected():
	$Selection.hide()
