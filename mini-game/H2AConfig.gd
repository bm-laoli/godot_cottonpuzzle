tool
extends Resource
class_name H2AConfig

enum Slot { NULL, TIME, SUN, FISH, HILL, CROS, CHOICE }

var placements := PoolIntArray()
var connections := {}

func _init():
	placements.resize(Slot.size())
	placements.fill(Slot.NULL)
	
	for slot in Slot.values():
		connections[slot] = []

# 下文是Godot 为我们提供的函数
func _get_property_list():
	var properties := [
		{
			name="placements",
			type=TYPE_INT_ARRAY,
			usage=PROPERTY_USAGE_STORAGE
		},
		{
			name="connections",
			type=TYPE_DICTIONARY,
			usage=PROPERTY_USAGE_STORAGE
		},
	]
	
	var options := PoolStringArray(Slot.keys()).join(",")
	for slot in range(1, Slot.size()):
		properties.append({
			name="placements/" + Slot.keys()[slot],
			type=TYPE_INT,
			usage=PROPERTY_USAGE_EDITOR,
			hint=PROPERTY_HINT_ENUM,
			hint_string=options
		})
		
	for slot in Slot.size()-1:
		var avaibale := PoolStringArray()
		for dst in Slot.size():
			if dst <= slot:
				avaibale.append("") # 在二进制下 ““ 空串 表示跳过的意思
			else:
				avaibale.append(Slot.keys()[dst])
		
		var hint_str = avaibale.join(",")
		properties.append({
			name="connections/" + Slot.keys()[slot],
			type=TYPE_INT,
			usage=PROPERTY_USAGE_EDITOR,
			hint=PROPERTY_HINT_FLAGS, # 表示选项是 二进制
			hint_string=hint_str
		})
	
	return properties

func _get(property):
	if property.begins_with("placements/"):
		property = property.trim_prefix("placements/")
		var index := Slot[property] as int
		return placements[index]
	
	if property.begins_with("connections/"):
		property = property.trim_prefix("connections/")
		var index := Slot[property] as int
		
		var value := 0 # 比特位都是0
		for dst in range(index+1, Slot.size()):
			if dst in connections[index]:
				value |= (1 << dst) # CS知识 移位运算
			# 1010010 左移 0001000 ，两个或一下 = 1011010  
		return value
		
	return null
	

func _set(property, value):
	if property.begins_with("placements/"):
		property = property.trim_prefix("placements/")
		var index := Slot[property] as int
		placements[index]=value
		emit_changed()
		return true

	if property.begins_with("connections/"):
		property = property.trim_prefix("connections/")
		var index := Slot[property] as int
		
		for dst in range(index+1, Slot.size()):
			_set_conneced(index, dst, (value & (1 << dst)) != 0 )
		emit_changed()
		return true
		
	return null

func _set_conneced(src:int, dst:int, connected: bool):
	var src_arr := connections[src] as Array
	var dst_arr := connections[dst] as Array
	var src_idx := src_arr.find(dst)
	var dst_idx := dst_arr.find(src)
	
	if connected:
		if src_idx == -1:
			src_arr.append(dst)
		if dst_idx == -1:
			dst_arr.append(src)
	else:
		if src_idx != -1:
			src_arr.remove(src_idx)
		if dst_idx != -1:
			dst_arr.remove(dst_idx)
