extends TextureButton

# Retrieve List and global variables
onready var itemList = get_node("/root/Node2D/CardSetList")

# Define list of card set names
var nameList = []

# When play button is clicked, save set names in global
func _on_PlaySelectScreen_pressed():
	# Makes sure that at least one item has been selected to be able to continue to game
	if (itemList.get_selected_items().size() >= 1):
		get_tree().change_scene("res://Scenes/Game.tscn")
