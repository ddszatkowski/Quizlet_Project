extends Node2D

# Get Enemy and Previous menu nodes
onready var enemy = preload("res://Scenes/Enemy.tscn")
onready var select = preload("res://Scenes/SelectMenu.tscn")
onready var laser = preload("res://Scenes/Laser.tscn")
# Get global variables, such as selected card set names
onready var global = get_node("/root/global")
onready var reticle = preload("res://Sprites/attack_reticle.png")

# Only lower healthbar on every other hit, can be hit / get 20 questions wrong on normal mode
var ignore_damage = true

# List of spawned enemies
var enemies = []
var group
# All selected card sets, merged
var card_dict
var Mouse_Position
var color = "Red"
var spawnTimer = 0
var shootCooldown = 0

var gun_strength = 10

var colors = ['R', 'B', 'P', 'Y', 'T', 'G']
var color_ind = randi()%len(colors)

var mouse_is_reticle = false

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var answers = []
	var index = 0
	var rand_num
	card_dict = global.cardSet
	# Adds all the answers to an array
	for question in card_dict:
		answers.append(card_dict[question])
	# Spawn an enemy per card in set
	for question in card_dict:
		var chosen_answers = []
		#Chooses indexes that are not the correct answer
		chosen_answers.append(answers[index])
		while (chosen_answers.size() < 4):
			rand_num = rng.randi_range(0, answers.size()-1)
			if !chosen_answers.has(answers[rand_num]):
				chosen_answers.append(answers[rand_num])
		chosen_answers.shuffle()
		# Adding the question, answers and the index of the correct answer to the new enemy
		add_enemy(question, chosen_answers, chosen_answers.find(answers[index]))
		index = index + 1
	# Setting the total number of enemies to be the number of cards for now
	global.num_enemies_left = len(card_dict)
	global.num_enemies_spawned = 0
	
	$RedButton.color = "Red"
	$BlueButton.color = "Blue"
	$GreenButton.color = "Green"
	$PurpleButton.color = "Purple"
	
func take_damage():
	if not ignore_damage:
		$Healthbar.damage()
	ignore_damage = not ignore_damage

# Declare new enemy, call initialization and add to this node as child
func add_enemy(question, answers, correct_answer_id):
	color_ind += 1
	if color_ind == len(colors):
		color_ind = 0
	var temp = enemy.instance()
	enemies = temp.init(enemies, question, answers, correct_answer_id, colors[color_ind])
	
func _process(delta):
	var mouseY = get_global_mouse_position().y
	if mouse_is_reticle and (mouseY > 850 or mouseY < 250):
		Input.set_custom_mouse_cursor(null)
		mouse_is_reticle = false
	if not mouse_is_reticle and (250 < mouseY and mouseY < 850):
		Input.set_custom_mouse_cursor(reticle, 0, Vector2(20,20))
		mouse_is_reticle = true
	
	if shootCooldown > 0:
		shootCooldown -= delta
	if len(enemies) == 0:
		return
	if spawnTimer <= 0:
		randomize()
		var rand_enemy = randi()%len(enemies)
		$EnemyList.add_child(enemies[rand_enemy])
		enemies.remove(rand_enemy)
		global.num_enemies_spawned += 1
		spawnTimer = global.spawnTimerMax
	else:
		spawnTimer -= delta
	
func _input(event):
	if not ($RedButton.pressed or $BlueButton.pressed or $GreenButton.pressed or $PurpleButton.pressed):
		return
	if Input.is_action_pressed("Click") and shootCooldown <= 0 and mouse_is_reticle:
		var soundNode = $"Sounds/LaserFired"
		soundNode.play()
		var temp = laser.instance()
		temp.init($LeftTurret.position + Vector2(-50, -150), get_global_mouse_position(), color, true, gun_strength/2)
		$lasers_good.add_child(temp)
		temp = laser.instance()
		temp.init($RightTurret.position + Vector2(-400, -150), get_global_mouse_position(), color, true, gun_strength/2)
		$lasers_good.add_child(temp)
		shootCooldown = .5