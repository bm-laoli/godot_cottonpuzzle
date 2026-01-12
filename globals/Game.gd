extends Node

# 路径要改 @TODO:
const SAVE_PATH := "user://data.sav"

class Flags:
	var _flags :=[]
	signal changed
	
	func has(flag:String) -> bool:
		return flag in _flags
		
	func add(flag: String):
		if flag in _flags:
			return
		_flags.append(flag)
		emit_signal("changed")
	
	func to_dict():
		return {
			flags = _flags,
		}
	
	func from_dict(dict: Dictionary):
		_flags = dict.flags
		emit_signal("changed")
	
	func reset():
		_flags.clear()
		emit_signal("changed")
	
class Inventory:
	signal changed
	
	var active_item : Item
	
	var _items := []
	var _current_item_idx := -1
	
	func get_item_count() -> int:
		return _items.size()
	
	func get_current_item() -> Item:
		if _current_item_idx == -1:
			return null
		return _items[_current_item_idx]
	
	func add_item(item:Item):
		if item in _items:
			return
		
		_items.append(item)
		_current_item_idx = _items.size() -1
		emit_signal("changed")
	
	func remove_item(item:Item):
		var idx := _items.find(item)
		if idx == -1:
			return
		
		_items.remove(idx)
		if _current_item_idx >= _items.size():
			_current_item_idx =0 if _items else -1
			
		emit_signal("changed")
		
	# 翻页面 涉及数学运算
	func select_next():
		if _current_item_idx == -1:
			return
		
		_current_item_idx = (_current_item_idx +1) % _items.size()
		emit_signal("changed")
	
	func select_prev():
		if _current_item_idx == -1:
			return
		
		_current_item_idx = (_current_item_idx -1 + _items.size()) % _items.size()
		emit_signal("changed")
	
	func to_dict():
		var names := []
		for item in _items:
			var path := item.resource_path as String
			names.append(path.get_file().get_basename())
		return {
			items=names,
			current_item_idx = _current_item_idx
		}
	
	func from_dict(dict: Dictionary):
		_current_item_idx = dict.current_item_idx
		_items.clear()
		for name in dict.items:
			_items.append(load("res://items/%s.tres" % name))
		emit_signal("changed")
	
	func reset():
		_current_item_idx=-1
		_items.clear()
		emit_signal("changed")

func save_game():
	var file := File.new()
	if file.open(SAVE_PATH, File.WRITE) != OK:
		return
	var data := {
		inventory=inventory.to_dict(),
		flags=flags.to_dict(),
		current_scene=get_tree().current_scene.filename.get_file().get_basename()
	} #这里还可以拓展存储下更多的信息 比如版本号 周目信息
	
	var json := to_json(data)
	file.store_string(json)

func load_game():
	var file := File.new()
	if file.open(SAVE_PATH, File.READ) != OK:
		return
	var json := file.get_as_text()
	var data := parse_json(json) as Dictionary
	inventory.from_dict(data.inventory)
	flags.from_dict(data.flags)
	SceneChanger.change_scene("res://scenes/%s.tscn" % data.current_scene)

func new_game():
	inventory.reset()
	flags.reset()
	SceneChanger.change_scene("res://scenes/H1.tscn")

func has_save_file() -> bool:
	return File.new().file_exists(SAVE_PATH)

func back_to_title():
	save_game()
	SceneChanger.change_scene("res://ui/TitleScreen.tscn")

var flags := Flags.new()
var inventory := Inventory.new()
