extends Sprite

#var shoot
var Mouse_Position
#export (PackedScene) var laser
#onready var Laser_container = get_node("Laser_container")
var red_tex = load("res://Sprites/red_turret.png")
var blue_tex = load("res://Sprites/blue_turret.png")
var green_tex = load("res://Sprites/green_turret.png")
var purple_tex = load("res://Sprites/purple_turret.png")


func _ready():
	set_process_input(true)
	texture = red_tex

#func _shoot():
#	look_at(get_global_mouse_position())
#	var pew = laser.instance()
#	Laser_container.add_child(pew)
	
#	pew.shoot(get_global_mouse_position(), global_position)
	
func _process(delta):
	Mouse_Position = get_local_mouse_position()
	rotation += Mouse_Position.angle() +.8

func _input(event):
	if event is InputEventMouseButton:
		if get_parent().color == "red":
			texture = red_tex
		if get_parent().color == "blue":
			texture = blue_tex
		if get_parent().color == "green":
			texture = green_tex
		if get_parent().color == "purple":
			texture = purple_tex