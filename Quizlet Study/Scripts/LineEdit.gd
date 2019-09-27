extends LineEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_focus():
		placeholder_text = ""
	pass

func _on_Import_pressed():
	$HTTPRequest.request(text)
	pass # Replace with function body.


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
    var html = body.get_string_from_utf8()
    var index = 0
    var wordStrs = []
    var defStrs = []
    while index != -1:
        index = html.findn('"word"', index)
        var wordStr = html.substr(index+8, 40)
        wordStr = wordStr.left(wordStr.find('"'))
        index = html.findn('"definition"', index)
        var defStr = html.substr(index + 14, 100)
        defStr = defStr.left(defStr.find('"'))
        if defStr != "":
            wordStrs.append(wordStr)
            defStrs.append(defStr)
    wordStrs.pop_back()
    defStrs.pop_back()
    print(wordStrs)
    print(defStrs)