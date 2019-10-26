extends TextureButton

# Retrieve List and global variables
onready var itemList = get_node("/root/Node2D/CardSetList")
onready var global = get_node("/root/global")

# Define list of card set names
var nameList = []

# When play button is clicked, save set names in global
func _on_PlaySelectScreen_pressed():
	# Makes sure that at least one item has been selected to be able to continue to game
	if (itemList.get_selected_items().size() >= 1):
		# For each selected index, save corresponding name
		for item in itemList.get_selected_items():
			nameList.append(itemList.get_item_text(item))
		# Import set into global
		global.importCards(nameList)
		# Start game
		get_tree().change_scene("res://Scenes/Game.tscn")
