extends Node2D

# Get Enemy and Previous menu nodes
onready var enemy = preload("res://Scenes/Enemy.tscn")
onready var select = preload("res://Scenes/SelectMenu.tscn")
onready var laser = preload("res://Scenes/Laser.tscn")
# Get global variables, such as selected card set names
onready var global = get_node("/root/global")
# This is the shield bar we need to change for health being lost
onready var bar = $TextureProgress
# List of spawned enemies
var enemies = []
var group
# All selected card sets, merged
var card_dict
var Mouse_Position
#health
onready var health = 100
var color = "Red"
var spawnTimer = 0
var shootCooldown = 0

var gun_strength = 10

var colors = ['R', 'B', 'P', 'Y', 'T', 'G']
var color_ind = 0#randi()%len(colors)


func _ready():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var answers = []
	var index = 0
	var rand_num
	var health = 100
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
	var player_max_health = 100
	bar.max_value = player_max_health
	bar.value = player_max_health
	
	$RedButton.color = "Red"
	$BlueButton.color = "Blue"
	$GreenButton.color = "Green"
	$PurpleButton.color = "Purple"

# Declare new enemy, call initialization and add to this node as child
func add_enemy(question, answers, correct_answer_id):
	color_ind += 1
	if color_ind == len(colors):
		color_ind = 0
	var temp = enemy.instance()
	enemies = temp.init(enemies, question, answers, correct_answer_id, colors[color_ind])
	
func _process(delta):
	if shootCooldown > 0:
		shootCooldown -= delta
	if global.num_enemies_spawned == len(enemies):
		return
	if spawnTimer <= 0:
		$EnemyList.add_child(enemies[global.num_enemies_spawned])
		global.num_enemies_spawned += 1
		spawnTimer = global.spawnTimerMax
	else:
		spawnTimer -= delta
	
func update_health(new_value):
	bar.value = new_value

func take_damage(count):
	health = health - count
	if health <= 0:
		health = 0
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	update_health(health)
	
func _input(event):
	if not ($RedButton.pressed or $BlueButton.pressed or $GreenButton.pressed or $PurpleButton.pressed):
		return
	if Input.is_action_pressed("Click") and shootCooldown <= 0:
		var soundNode = $"Sounds/LaserFired"
		soundNode.play()
		var temp = laser.instance()
		temp.init($LeftTurret.position + Vector2(-50, -150), get_global_mouse_position(), color, true, gun_strength/2)
		$lasers_good.add_child(temp)
		temp = laser.instance()
		temp.init($RightTurret.position + Vector2(-400, -150), get_global_mouse_position(), color, true, gun_strength/2)
		$lasers_good.add_child(temp)
		shootCooldown = .5