extends LineEdit

# Hide placeholder if clicked
func _process(delta):
	if has_focus():
		placeholder_text = ""

# When import button clicked, fetch resource from URL
func _on_Import_pressed():
	$HTTPRequest.request(text)

# When resource retrieved, save as card set
func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var index = 0
	var set_dict = {}
	var save_game = File.new()
	var save_dict = {}
	
	var html = body.get_string_from_utf8()
	
	# Retrieve title of set from URL
	var start_ind = html.findn('<title>', 0) + 7
	var break_ind = html.findn(' Flashcards', start_ind)
	var title = html.substr(start_ind, break_ind - start_ind)
	
	# If set with name is already saved, write over it
	if(save_game.file_exists("res://savegame.json")):
		save_game.open("res://savegame.json", File.READ)
		save_dict = parse_json(save_game.get_as_text())
		save_game.close()
	
	# Find each word/definition set and save as card
	while index != -1:
		index = html.findn('"word"', index)
		var wordStr = html.substr(index+8, 200)
		wordStr = wordStr.left(wordStr.find('"'))
		index = html.findn('"definition"', index)
		var defStr = html.substr(index + 14, 200)
		defStr = defStr.left(defStr.find('"'))
		# Filters out incorrect catches
		if defStr != "" and defStr.findn("html lang") == -1:
			set_dict[wordStr] = defStr
	
	# Save set to whole file under title
	save_dict[title] = set_dict

	# Save new file
	save_game.open("res://savegame.json", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()