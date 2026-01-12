extends Node

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
	
	
func back_to_title():
	SceneChanger.change_scene("res://ui/TitleScreen.tscn")

var flags := Flags.new()
var inventory : =Inventory.new()
