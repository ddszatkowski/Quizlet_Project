extends LineEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_focus():
		placeholder_text = ""
	pass

func _on_Import_pressed():
	$HTTPRequest.request(text)
	pass # Replace with function body.


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var html = body.get_string_from_utf8()
	
	var start_ind = html.findn('<title>', 0) + 7
	var break_ind = html.findn(' Flashcards', start_ind)
	var title = html.substr(start_ind, break_ind - start_ind)
	
	var save_game = File.new()
	var save_dict = {}
	if(save_game.file_exists("res://savegame.json")):
		save_game.open("res://savegame.json", File.READ)
		save_dict = parse_json(save_game.get_as_text())
		save_game.close()
	var index = 0
	var set_dict = {}
	while index != -1:
		index = html.findn('"word"', index)
		var wordStr = html.substr(index+8, 200)
		wordStr = wordStr.left(wordStr.find('"'))
		index = html.findn('"definition"', index)
		var defStr = html.substr(index + 14, 200)
		defStr = defStr.left(defStr.find('"'))
		if defStr != "" and defStr.findn("html lang") == -1:
			set_dict[wordStr] = defStr
	
	save_dict[title] = set_dict

	save_game.open("res://savegame.json", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	print("Game Saved!")