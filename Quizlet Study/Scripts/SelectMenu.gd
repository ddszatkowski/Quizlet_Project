extends Node2D

onready var itemList = get_node("CardSetList")

# List out saved sets in selector
func _ready():
	var save_game = File.new()
	var save_dict = {}
	save_game.open("res://savegame.json", File.READ)
	save_dict = parse_json(save_game.get_as_text())
	save_game.close()
	itemList.clear()
	for i in save_dict.keys():
		 itemList.add_item(i)
