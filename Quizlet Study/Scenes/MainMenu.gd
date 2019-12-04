extends Node2D

onready var global = get_node("/root/global")

func _ready():
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	global._play(false)
