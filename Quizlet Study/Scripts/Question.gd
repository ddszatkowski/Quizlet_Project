extends Label

var totalMsg = "    NO TARGET SELECTED"
var currMsg = ""

# How many seconds between each letter display
var charTime = .1

# Counter for when to add letters
var changeTime = 0
var font
var correctAnswer

var numberTimesAnswered = 0

# Set starting font to large
func _ready():
	font = get_font("")
	font.size = 75
	
# Add letter if passed time larger than charTime and letters are left
func _process(delta):
	if changeTime > charTime and currMsg.length() < totalMsg.length():
		currMsg += totalMsg[currMsg.length()]
		changeTime -= charTime
	else:
		changeTime += delta
	text = currMsg

# Clears currMes and changes target message
func changeMessage(msg):
	totalMsg = msg
	currMsg = ""

func _on_Enemy_selected():
	changeMessage("Damn, not working")

func _answered(answer):
	if(answer == correctAnswer):
		on_answer_correctly()
		
func on_answer_correctly():
	numberTimesAnswered += 1
