extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# warning-ignore:unused_class_variable
onready var itemList = get_node("/root/Node2D/CardSetList")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_PlaySelectScreen_pressed():
	print ("Selected card decks by index in JSON file: ")
	print (itemList.get_selected_items())
	get_tree().change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.
