extends LineEdit

# Hide placeholder if clicked
# warning-ignore:unused_argument
func _process(delta):
	if has_focus():
		placeholder_text = ""

func _on_Button_pressed():
	var index = 0
	var set_dict = {}
	var save_game = File.new()
	var save_dict = {}
	var title = text
	
	# If set with name is already saved, write over it
	if(save_game.file_exists("res://savegame.json")):
		save_game.open("res://savegame.json", File.READ)
		save_dict = parse_json(save_game.get_as_text())
		save_game.close()
	
	# Find each word/definition set and save as card
	var child = get_node("CardText")
	var textChild = child.called()
	var childAvailable = true
	var count = 0
	while(childAvailable):
		index = textChild.findn(';')
		count = count+1
		var wordStr = String(textChild.substr(0, index))
		textChild = textChild.substr(index + 1, textChild.length())
		
		var defStr
		index = wordStr.findn(',')
		if(textChild == ';' or textChild == ""):
			childAvailable = false
		if(index != -1):
			
			defStr = String(wordStr.substr(index+1, wordStr.length()))
			# Filters out incorrect catches
			wordStr = wordStr.substr(0, index)
			if(textChild == ';'):
				childAvailable = false
		set_dict[defStr] = wordStr
	
	# Save set to whole file under title
	if(count >= 4):
		save_dict[title] = set_dict
		print(set_dict)

		save_game.open("res://savegame.json", File.WRITE)
		save_game.store_line(to_json(save_dict))
		save_game.close()
		get_tree().change_scene("res://Scenes/ImportMenu.tscn")

