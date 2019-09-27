extends CanvasLayer

func _ready():
    pass

func _on_Button_pressed():
    $HTTPRequest.request("https://quizlet.com/356497723/monster-flash-cards/")

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