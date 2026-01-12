tool
extends Interactable
class_name H2AStone

var target_slot :int setget set_target_slot
var current_slot :int setget set_current_slot

func set_target_slot(v: int):
	target_slot = v
	_update_texture()

func set_current_slot(v: int):
	current_slot = v
	_update_texture()

func _update_texture():
	var idx := target_slot
	if target_slot != current_slot:
		idx += H2AConfig.Slot.size() -1 
	set_texture(load("res://assets/H2A/SS_%02d.png" % idx))
