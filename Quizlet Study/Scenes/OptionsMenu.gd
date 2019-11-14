extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var global = get_node("/root/global")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.spawnTimerMax = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OptionButton_item_selected(ID):
	var num = ID
	global.spawnTimerMax = 3
	if(num > 0):
		global.spawnTimerMax = 5
	if(num >1):
		global.spawnTimerMax = .5
	pass # Replace with function body.
