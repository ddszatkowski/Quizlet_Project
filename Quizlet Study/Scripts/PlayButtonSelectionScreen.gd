extends Button

# Retrieve List and global variables
onready var itemList = get_node("/root/Node2D/CardSetList")
onready var global = get_node("/root/global")
# Define list of card set names
var nameList = []


func _on_PlayButtonSelectionScreen_pressed():
	# Makes sure that at least one item has been selected to be able to continue to game
	if (itemList.get_selected_items().size() >= 1):
		get_tree().change_scene("res://Scenes/Game.tscn")
