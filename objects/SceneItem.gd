tool
extends Interactable
class_name SceneItem

export var item: Resource setget set_item

func _ready():
	if Engine.editor_hint:
		return

	if Game.flags.has(_get_flgs()):
		queue_free()

func set_item(v: Item):
	item = v
	set_texture(item.scene_texture if item else null)
	#3.x Godot 版本的一个bug： 在一个导出变量的set里运用了另一个导出变量的set，
	#它只能刷新 item 而不是刷新另一个texure 我们需要手动all
	property_list_changed_notify()

func _interact():
	._interact()
	
	#存储一个被拾取的状态
	Game.flags.add(_get_flgs())
	Game.inventory.add_item(item)
	
	# 一个占位的假消失 这样可以做一个动画出来 直接让本体去动画 可能不安全
	var sprite := Sprite.new()
	sprite.texture = item.scene_texture
	get_parent().add_child(sprite)
	sprite.global_position = global_position
	
	var tween := sprite.create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, 'scale', Vector2.ZERO, 0.15)
	tween.tween_callback(sprite, 'queue_free')
	
	queue_free()
	

func _get_flgs():
	return "picked:" + item.resource_path.get_file()
