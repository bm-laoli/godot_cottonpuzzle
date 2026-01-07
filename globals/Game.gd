extends Node

class Flags:
	var _flags :=[]
	signal changed
	
	func has(flag:String):
		return flag in _flags
		
	func add(flag: String):
		if flag in _flags:
			return
		_flags.append(flag)
		emit_signal("changed")

var flags := Flags.new()
