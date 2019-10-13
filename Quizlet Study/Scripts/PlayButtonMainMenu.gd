extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	var save_game = File.new()
	var save_dict = {}
	if(save_game.file_exists("res://savegame.json")):
		save_game.open("res://savegame.json", File.READ)
		save_dict = parse_json(save_game.get_as_text())
		save_game.close()
		if (save_dict == {}):
			get_tree().change_scene("res://Scenes/ImportMenu.tscn")
		else:
			get_tree().change_scene("res://Scenes/SelectMenu.tscn")
	else:
		get_tree().change_scene("res://Scenes/ImportMenu.tscn")
	pass # Replace with function body.
