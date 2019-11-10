extends Label

onready var itemList = get_node("/root/Node2D/CardSetList")
onready var global = get_node("/root/global")

var nameList = []

		
func update_preview():
	if global.cardSet.size() > 0:
		var first_key = ''
		for key in global.cardSet:
			first_key = key
			break
		$QuestionPreview.text = first_key
		$AnswerPreview.text = global.cardSet[first_key]
	else:
		$QuestionPreview.text = ''
		$AnswerPreview.text = ''

func _on_SwapButton_pressed():
	
	for key in global.cardSet.keys():
		global.cardSet[global.cardSet[key]] = key
		global.cardSet.erase(key)
	update_preview()

func _on_CardSetList_item_activated(index):
	nameList = []
	for item in itemList.get_selected_items():
			nameList.append(itemList.get_item_text(item))
	global.importCards(nameList)
	update_preview()
