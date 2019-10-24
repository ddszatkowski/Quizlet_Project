extends Control

var group
# Called when the node enters the scene tree for the first time.
func _ready():
	group = ButtonGroup.new()
	
	$RedButton.set_button_group(group)
	$BlueButton.set_button_group(group)
	$GreenButton.set_button_group(group)
	$PurpleButton.set_button_group(group)
	
	
func _on_RedButton_toggled(button_pressed):
	print("Red")
	get_parent().color = "red"
	
func _on_BlueButton_toggled(button_pressed):
	print("Blue")
	get_parent().color = "blue"
	
func _on_GreenButton_toggled(button_pressed):
	print("Green")
	get_parent().color = "green"
	
func _on_PurpleButton_toggled(button_pressed):
	print("Purple")
	get_parent().color = "purple"