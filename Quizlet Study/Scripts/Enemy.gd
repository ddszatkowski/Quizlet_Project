extends KinematicBody2D

onready var question_display = get_tree().get_root().get_node("Game/QuestionScreen/Question")
onready var red_button = get_tree().get_root().get_node("Game/RedButton")
onready var blue_button = get_tree().get_root().get_node("Game/BlueButton")
onready var green_button = get_tree().get_root().get_node("Game/GreenButton")
onready var purple_button = get_tree().get_root().get_node("Game/PurpleButton")
onready var red_button_display = red_button.get_children()[0]
onready var blue_button_display = blue_button.get_children()[0]
onready var green_button_display = green_button.get_children()[0]
onready var purple_button_display = purple_button.get_children()[0]
onready var left_turret = get_tree().get_root().get_node("Game/LeftTurret")
onready var left_turret_muzzle = get_tree().get_root().get_node("Game/LeftTurret/Muzzle")
onready var laser = preload("res://Scenes/Laser.tscn")
onready var global = get_node("/root/global")

var velocity = Vector2()
var collision_type = "Enemy"

# Bounds of Movement
var x_max = ProjectSettings.get_setting("display/window/size/width") * 9/8
var y_max = ProjectSettings.get_setting("display/window/size/height")
var x_min = x_max / 4
var y_min = y_max / 2

var strength = 10

var target_pos
var top_speed = 5
var scaleVar = Vector2(.2,.2)
var question
var answers_array
var correct_answer_index
var is_selected = false
var buttons
var shielding_or_dying = false
signal selected(id)

# Time increments within shoot_wait at which animation changes
var charge_steps = [4, 3, 2, 1]

# Once ship is close enough, counts down to 0, then fires lasers
var shoot_wait = charge_steps[0]
var shoot_wait_max = 10


func change_color(color):
	var frames = $AnimatedSprite.get_sprite_frames().duplicate()
	var animations = ["f", "l", "charge1", "charge2", "charge3"]
	for animation in animations:
		var img = Image.new()
		img.load("Sprites/enemy" + color + "_" + animation + ".png")
		var itex = ImageTexture.new()
		itex.create_from_image(img)
		frames.clear(animation)
		frames.add_frame(animation, itex)
	$AnimatedSprite.set_sprite_frames(frames)
	
		
# Should be called when enemy is spawned. 
# Stores question and connects signals to all other enemies
func init(enemies, q, a, a_id, color):
	change_color(color)
	question = q
	answers_array = a
	correct_answer_index = a_id
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
	set_scale(scaleVar)
	
	# First shoot is immediately after reaching ship
	shoot_wait = charge_steps[0]
	buttons = [red_button, blue_button, green_button, purple_button]
	
	# Hide Shield
	$ShieldAnimation.set_scale(Vector2(3, 3))
	$ShieldAnimation.hide()
	
	$Selection.hide()

# Find location within bounds that is at least 80 pixels from current position
func generate_destination():
	target_pos = Vector2(randf()*(x_max-x_min) + x_min, randf()*(y_max-y_min) + y_min)
	while (target_pos - position).length() < 80:
		target_pos = Vector2(randf()*(x_max-x_min) + x_min, randf()*(y_max-y_min) + y_min)
	

func _process(delta):
	# If enemy is in the process of dying, stop and do that
	if !shielding_or_dying:
		# Set scale of enemy to variable
		set_scale(scaleVar)
		
		# Keep Selection scale from inheriting from enemy
		$Selection.scale.x = 2/(scale.x)
		$Selection.scale.y = 2/(scale.y)
		
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
			$AnimatedSprite.animation = "l"
			
		else:
			# Change sprite based on level of charge
			if shoot_wait > charge_steps[1]:
				$AnimatedSprite.animation = "f"
			elif shoot_wait > charge_steps[2]:
				$AnimatedSprite.animation = "charge1"
			elif shoot_wait > charge_steps[3]:
				$AnimatedSprite.animation = "charge2"
			elif shoot_wait > 0:
				$AnimatedSprite.animation = "charge3"
			# If finished, shoot lasers
			else:
				shootLaser()
				$AnimatedSprite.animation = "f"
				shoot_wait = shoot_wait_max
			shoot_wait -= delta
		
# Spawn lasers at ship cannons, move them to absolute coordinates at bottom of screen
func shootLaser():
	var temp = laser.instance()
	temp.init(position + Vector2(-30, 20), Vector2(x_min, 2*y_max), "Red", false, strength/2)
	get_parent().get_parent().get_node("lasers_bad").add_child(temp)
	temp = laser.instance()
	temp.init(position + Vector2(30, 20), Vector2(x_max, 2*y_max), "Red", false, strength/2)
	get_parent().get_parent().get_node("lasers_bad").add_child(temp)

# If received selected signal from another enemy, hide selection cursor
func _on_Enemy_selected():
	is_selected = false
	$Selection.hide()

# Checks if the lazers hit the ship and if it was the correct answer or not
func _on_Area2D_area_entered(area):
	if !shielding_or_dying:
		var collide = area.get_parent()
		if collide.collision_type == "Laser" and collide.friend:
			# Check if answer is correct
			# Find which button is pressed
			var index_pressed = -1
			for ind in range(0, 4):
				if buttons[ind].pressed:
					index_pressed = ind
					
			# If correct button pressed, shoot laser and destroy ship
			if correct_answer_index == index_pressed and is_selected:
				# Since game is about to kill enemy stop having it move around
				# Shoot laser at ship
				shielding_or_dying = true
				red_button.set_pressed(false)
				blue_button.set_pressed(false)
				green_button.set_pressed(false)
				purple_button.set_pressed(false)
				# Checks for game over - i.e. all enemies have been killed
				global.num_enemies_left = global.num_enemies_left - 1
				if (global.num_enemies_left <= 0):
					get_tree().change_scene("res://Scenes/GameOver.tscn")
				# Resets the labels and deactivated the buttons until another ship is selected
				question_display.changeMessage("NO TARGET SELECTED")
				red_button_display.text = ""
				blue_button_display.text = ""
				green_button_display.text = ""
				purple_button_display.text = ""
				red_button.disabled = true
				blue_button.disabled = true
				green_button.disabled = true
				purple_button.disabled = true
				#Explosion animation
				$AnimatedSprite.set_scale(Vector2(2, 2))
				$AnimatedSprite.play("Explosion")
				var soundNode = $"Sounds/ExplosionSound"
				soundNode.play()
				get_parent().remove_child(collide)
				collide.queue_free()
				yield(get_tree().create_timer(.3), "timeout")
				# Deletes enemy
				self.queue_free()
			elif correct_answer_index != index_pressed and is_selected:
				shielding_or_dying = true
				$ShieldAnimation.show()
				collide.reflect()
				var soundNode = $"Sounds/ShieldSound"
				soundNode.play()
				#get_parent().remove_child(collide)
				#collide.queue_free()
				yield(get_tree().create_timer(.3), "timeout")
				$ShieldAnimation.hide()
				shielding_or_dying = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("Click"):
		
		# Find which button is pressed
		var index_pressed = -1
		for ind in range(0, 4):
			if buttons[ind].pressed:
				index_pressed = ind
				
		# If no button pressed, select ship
		if index_pressed == -1:
			is_selected = true
			emit_signal("selected")
			$Selection.show()
			# Update display to show question
			question_display.changeMessage(question)
			# Update display of buttons to show potential answers
			red_button.set_display(answers_array[0])
			blue_button.set_display(answers_array[1])
			green_button.set_display(answers_array[2])
			purple_button.set_display(answers_array[3])
			red_button.disabled = false
			blue_button.disabled = false
			green_button.disabled = false
			purple_button.disabled = false
			return
			
			

