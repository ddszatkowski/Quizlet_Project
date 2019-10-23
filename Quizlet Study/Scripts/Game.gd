extends Node2D

# Get Enemy and Previous menu nodes
onready var enemy = preload("res://Scenes/Enemy.tscn")
onready var select = preload("res://Scenes/SelectMenu.tscn")
# Get global variables, such as selected card set names
onready var global = get_node("/root/global")
# List of spawned enemies
var enemies = []
# All selected card sets, merged
var card_dict

func _ready():
	# Spawn an enemy per card in set
	card_dict = global.cardSet
	for question in card_dict:
		add_enemy(question)
	
# Declare new enemy, call initialization and add to this node as child
func add_enemy(question):
	var temp = enemy.instance()
	enemies = temp.init(enemies, question)
	add_child(temp)