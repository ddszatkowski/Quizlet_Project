extends Node

var cardSet = {}
var num_enemies_left # Set in ready func of game script, when this reaches 0 it goes to game over screen
var num_enemies_spawned
# Fills cardSet with all cards in sets named within set variable
func importCards(set):
	cardSet = {}
	
	if set.size() == 0:
		return
	var save_game = File.new()
	var card_dict = {}
	# Store all card sets in variable
	if(save_game.file_exists("res://savegame.json")):
		save_game.open("res://savegame.json", File.READ)
		card_dict = parse_json(save_game.get_as_text())
		save_game.close()
		
	# Merge all sets with names in name
	for name in set:
		var set_dict = card_dict[name]
		for question in set_dict:
			cardSet[question] = set_dict[question]