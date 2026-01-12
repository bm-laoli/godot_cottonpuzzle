tool
extends Node2D

const SLOT_TEXTURE = preload("res://assets/H2A/CIRCLE.png")
const LINE_TEXTURE = preload("res://assets/H2A/CIRCLELINE.png")

export var radius := 100.0 setget set_radius
export var config: Resource setget set_config

var _stone_map := {}

func _ready():
	_update_borad()

func _draw():
	for slot in H2AConfig.Slot.size():
		draw_texture(
			SLOT_TEXTURE,
			_get_slot_postion(slot)-SLOT_TEXTURE.get_size() / 2
		)

func set_radius(v:float):
	radius = v
	update()

func _get_slot_postion(slot: int) -> Vector2:
	return Vector2.DOWN.rotated(TAU / H2AConfig.Slot.size() * slot) * radius

func set_config(v: H2AConfig):
	if config and config.is_connected("changed",self, "_update_borad"):
		config.disconnect("changed",self, '_update_borad')
	
	config = v
	if config and not config.is_connected("changed",self, '_update_borad'):
		config.connect("changed",self,'_update_borad')

func _update_borad_A():
	pass

func _update_borad():
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	
	if not config:
		return
		
	print('前缀 执行代码->',H2AConfig.Slot.size())
	
	for src in H2AConfig.Slot.size():
		for dst in range(src + 1, H2AConfig.Slot.size()):
			if not dst in config.connections[src]:
				continue
			
			var line := Line2D.new()
			add_child(line)
			line.add_point(_get_slot_postion(src))
			line.add_point(_get_slot_postion(dst))
			line.width= LINE_TEXTURE.get_size().y
			line.texture = LINE_TEXTURE
			line.texture_mode = Line2D.LINE_TEXTURE_TILE
			line.default_color = Color.white
			line.show_behind_parent = true
			
	print('执行代码->',H2AConfig.Slot.size())
	
	for slot in range(1, H2AConfig.Slot.size()):
		var stone := H2AStone.new()
		print('开始渲染',stone)
		add_child(stone)
		stone.target_slot = slot
		stone.current_slot = config.placements[slot]
		stone.position = _get_slot_postion(stone.current_slot)
		_stone_map[slot]=stone
		stone.connect("interact",self,'_request_move',[stone])

func _request_move(stone: H2AStone):
	var avaliable := H2AConfig.Slot.values()
	
	for s in _stone_map.values():
		avaliable.erase(s.current_slot)
	assert(avaliable.size() == 1)
	var avaliable_slot := avaliable.front() as int
	if avaliable_slot in config.connections[stone.current_slot]:
		_move_stone(stone, avaliable_slot)

func _move_stone(stone: H2AStone, slot: int):
	stone.current_slot = slot
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(stone, 'position', _get_slot_postion(slot) ,0.2)
	
	#状态保存一下是否 通关
	tween.tween_interval(1.0)
	tween.tween_callback(self, '_check')

func _check():
	for stone in _stone_map.values():
		if stone.current_slot != stone.target_slot:
			return
	Game.flags.add('h2a_unlocked')
	SceneChanger.change_scene("res://scenes/H2.tscn")
		
func reset():
	for stone in _stone_map.values():
		_move_stone(stone, config.placements[stone.target_slot])
