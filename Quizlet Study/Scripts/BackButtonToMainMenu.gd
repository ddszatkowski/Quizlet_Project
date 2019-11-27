extends Button
var optionButton = OptionButton
onready var global = get_node("/root/global")

func _on_New_pressed():
	get_tree().change_scene("res://Scenes/CreateNewCards.tscn")


func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
