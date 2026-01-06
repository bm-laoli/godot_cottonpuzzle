tool
extends Area2D
class_name Interactable

signal interact

export var texture: Texture setget set_texture

func _input_event(viewport, event, shape_idx):
	if not event.is_action_pressed("interact"):
		return

	_interact()

func _interact():
	emit_signal("interact")

func set_texture(v: Texture):
	texture = v
	
	#如果发现含有重复添加的 就删掉
	for node in get_children():
		if node.owner == null:
			node.queue_free()
	
	#通过程序 + 入新东西
	if texture == null:
		return
	
	var sprite := Sprite.new()
	sprite.texture = texture
	add_child(sprite)
	
	var rect := RectangleShape2D.new()
	rect.extents = v.get_size() /2
	
	var collider := CollisionShape2D.new()
	collider.shape = rect
	add_child(collider)
