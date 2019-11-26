extends Button
var optionButton = OptionButton
onready var global = get_node("/root/global")

func _on_New_pressed():
	get_tree().change_scene("res://Scenes/ImportMenu.tscn")
