extends TextureRect

var health = 10

func damage():
	get_child(health-1).animation = 'Empty'
	health -= 1
	if health <= 0:
		health = 0
		get_tree().change_scene("res://Scenes/GameOver.tscn")