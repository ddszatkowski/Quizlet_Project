extends Node2D

# Declare member variables here. Examples:
onready var itemList = get_node("CardSetList")

# Called when the node enters the scene tree for the first time.
func _ready():
	var save_game = File.new()
	var save_dict = {}
	save_game.open("res://savegame.json", File.READ)
	save_dict = parse_json(save_game.get_as_text())
	save_game.close()
	itemList.clear()
	for i in save_dict.keys():
		 itemList.add_item(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
