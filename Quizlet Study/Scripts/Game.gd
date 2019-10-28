extends Node2D

# Get Enemy and Previous menu nodes
onready var enemy = preload("res://Scenes/Enemy.tscn")
onready var select = preload("res://Scenes/SelectMenu.tscn")
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
var color = "red"


func _ready():
	# In scope temp variables
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
	global.num_enemies = index - 1
	var player_max_health = 100
	bar.max_value = player_max_health
	bar.value = player_max_health
	
	group = ButtonGroup.new()
	$RedButton.set_button_group(group)
	$BlueButton.set_button_group(group)
	$GreenButton.set_button_group(group)
	$PurpleButton.set_button_group(group)
	$RedButton.disabled = true
	$BlueButton.disabled = true
	$GreenButton.disabled = true
	$PurpleButton.disabled = true

# Declare new enemy, call initialization and add to this node as child
func add_enemy(question, answers, correct_answer_id):
	var temp = enemy.instance()
	enemies = temp.init(enemies, question, answers, correct_answer_id)
	$EnemyList.add_child(temp)

func update_health(new_value):
	bar.value = new_value

func take_damage(count):
	health = health - count
	if health <= 0:
		health = 0
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	update_health(health)
	
func _on_RedButton_toggled(button_pressed):
	color = "red"
	
func _on_BlueButton_toggled(button_pressed):
	color = "blue"
	
func _on_GreenButton_toggled(button_pressed):
	color = "green"
	
func _on_PurpleButton_toggled(button_pressed):
	color = "purple"