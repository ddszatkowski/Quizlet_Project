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
var health
var color = "red"


func _ready():
	# Spawn an enemy per card in set
	card_dict = global.cardSet
	for question in card_dict:
		add_enemy(question)
	var player_max_health = 100
	bar.max_value = player_max_health
	bar.value = player_max_health
	
	group = ButtonGroup.new()
	
	$RedButton.set_button_group(group)
	$BlueButton.set_button_group(group)
	$GreenButton.set_button_group(group)
	$PurpleButton.set_button_group(group)
	
# Declare new enemy, call initialization and add to this node as child
func add_enemy(question):
	var temp = enemy.instance()
	enemies = temp.init(enemies, question)
	add_child(temp)

func _on_hit_health_changed(health):
	take_damage(20)
	update_health(health)
	
func update_health(new_value):
	bar.value = new_value

func take_damage(count):
	health -= count
	if health <= 0:
		health = 0
		get_tree().change_scene("res://Scenes/GameOver.tscn")

	bar.value = health
	

func _on_RedButton_toggled(button_pressed):
	print("Red")
	color = "red"
	
func _on_BlueButton_toggled(button_pressed):
	print("Blue")
	color = "blue"
	
func _on_GreenButton_toggled(button_pressed):
	print("Green")
	color = "green"
	
func _on_PurpleButton_toggled(button_pressed):
	print("Purple")
	color = "purple"