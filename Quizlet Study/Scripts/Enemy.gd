extends KinematicBody2D

onready var question_display = get_tree().get_root().get_node("Game/QuestionScreen/Question")
onready var red_button = get_tree().get_root().get_node("Game/RedButton")
onready var blue_button = get_tree().get_root().get_node("Game/BlueButton")
onready var green_button = get_tree().get_root().get_node("Game/GreenButton")
onready var purple_button = get_tree().get_root().get_node("Game/PurpleButton")
onready var red_button_display = get_tree().get_root().get_node("Game/RedButtonLabel")
onready var blue_button_display = get_tree().get_root().get_node("Game/BlueButtonLabel")
onready var green_button_display = get_tree().get_root().get_node("Game/GreenButtonLabel")
onready var purple_button_display = get_tree().get_root().get_node("Game/PurpleButtonLabel")
onready var target = get_tree().get_root().get_node("Game/")
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
signal selected(id)

# Time increments within shoot_wait at which animation changes
var charge_steps = [4, 3, 2, 1]

# Once ship is close enough, counts down to 0, then fires lasers
var shoot_wait = charge_steps[0]
var shoot_wait_max = 10


# Should be called when enemy is spawned. 
# Stores question and connects signals to all other enemies
func init(enemies, q, a, a_id):
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
			target.take_damage(strength)
		shoot_wait -= delta
		
# Spawn lasers at ship cannons, move them to absolute coordinates at bottom of screen
func shootLaser():
	var temp = laser.instance()
	temp.init(position + Vector2(-30, 20), Vector2(x_min, 2*y_max), "Red", false)
	get_parent().get_parent().get_node("lasers_bad").add_child(temp)
	temp = laser.instance()
	temp.init(position + Vector2(30, 20), Vector2(x_max, 2*y_max), "Red", false)
	get_parent().get_parent().get_node("lasers_bad").add_child(temp)

# If received selected signal from another enemy, hide selection cursor
func _on_Enemy_selected():
	is_selected = false
	$Selection.hide()


func _on_Area2D_area_entered(area):
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
			# Shoot laser at ship
			red_button.set_pressed(false)
			blue_button.set_pressed(false)
			green_button.set_pressed(false)
			purple_button.set_pressed(false)
			# Checks for game over - i.e. all enemies have been killed
			global.num_enemies_left = global.num_enemies_left - 1
			if (global.num_enemies_left <= 0):
				get_tree().change_scene("res://Scenes/GameOver.tscn")
			# Resets the labels and deactivated the buttons until another ship is selected
			question_display.changeMessage("")
			red_button_display.update_text("")
			blue_button_display.update_text("")
			green_button_display.update_text("")
			purple_button_display.update_text("")
			red_button.disabled = true
			blue_button.disabled = true
			green_button.disabled = true
			purple_button.disabled = true
			# Deletes enemy
			get_parent().remove_child(collide)
			self.queue_free()


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
			red_button_display.update_text(answers_array[0])
			blue_button_display.update_text(answers_array[1])
			green_button_display.update_text(answers_array[2])
			purple_button_display.update_text(answers_array[3])
			red_button.disabled = false
			blue_button.disabled = false
			green_button.disabled = false
			purple_button.disabled = false
			return
