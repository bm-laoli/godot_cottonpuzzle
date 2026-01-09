extends Node2D
class_name FlagSwitch

export var flag: String

# 当可交互物品 存在/不存在 的时候切换的节点
var defalut_node: Node2D
var switch_node: Node2D 

func _ready():
	var count  := get_child_count()
	if count >0:
		defalut_node = get_child(0)
	if count >1:
		switch_node = get_child(1)
	
	Game.flags.connect("changed",self, "_update_nodes")
	_update_nodes()

func _update_nodes():
	var exists := Game.flags.has(flag)
	if defalut_node:
		defalut_node.visible = not exists
	if switch_node:
		switch_node.visible = exists
