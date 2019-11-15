extends Label

var totalMsg
var currMsg

# How many seconds between each letter display
var charTime

# Counter for when to add letters
var changeTime = 0
var font
var numberTimesAnswered = 0

var rowSizeMax = 1900
var ySizeMax = 200
var rowInd
var charInd

onready var start = get_global_position()

var changeCount = 0
var lastmsg = ''
var shiftLeft = false

# Set starting font to large
func _ready():
	font = get_font("")
	changeMessage("NO TARGET SELECTED")
	
# Add letter if passed time larger than charTime and letters are left
func _process(delta):
	if changeTime > charTime and rowInd < totalMsg.size():
		currMsg += totalMsg[rowInd][charInd]
		charInd += 1
		changeTime = 0
		if charInd >= totalMsg[rowInd].length():
			currMsg += '\n'
			rowInd += 1
			charInd = 0
	else:
		changeTime += delta
	text = currMsg

# Clears currMes and changes target message
func changeMessage(msg):
	if lastmsg == msg:
		return
		
	if lastmsg.length() > 50:
		shiftLeft = true
		
	lastmsg = msg
	changeTime = 0
	currMsg = ''
	rowInd = 0
	charInd = 0
	totalMsg = []
	
	changeCount += 1
	
	if msg.length() < 50:
		font.size = 100
	else:
		var size = 99
		var rows = msg.length() / int(rowSizeMax / size)
		if msg.length() / int(rowSizeMax / size) != 0:
			rows += 1
		while size * rows > ySizeMax:
			size -= 1
			rows = msg.length() / int(rowSizeMax / size)
			if msg.length() / int(rowSizeMax / size) != 0:
				rows += 1
			var temp = size * rows
		font.size = size
		
	charTime = 2 / msg.length()
	while msg.length() != 0:
		var temp = int(rowSizeMax / font.size)
		totalMsg.append(msg.substr(0, temp))
		msg = msg.substr(temp, msg.length()-temp)
	
	var xpos = start.x
	if shiftLeft:
		xpos = start.x - 200
	set_global_position(Vector2(xpos, start.y - (totalMsg.size() - 1)*20))

func _answered(answer):
	on_answer_correctly()
		
func on_answer_correctly():
	numberTimesAnswered += 1
