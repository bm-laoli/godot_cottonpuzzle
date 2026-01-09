extends VBoxContainer

var _hand_outro: SceneTreeTween
var _label_outro: SceneTreeTween

onready var label = $Label
onready var prev = $ItemBar/Prev
onready var prop = $ItemBar/Use/Prop
onready var hand = $ItemBar/Use/Hand
onready var next = $ItemBar/Next
onready var timer = $Label/Timer

func _ready():
	#Game.inventory.add_item(preload("res://items/key.tres"))
	#Game.inventory.add_item(preload("res://items/mail.tres"))
	
	hand.hide()
	hand.modulate.a = 0.0
	label.hide()
	label.modulate.a = 0.0
	
	Game.inventory.connect("changed", self, "_update_ui")	
	_update_ui(true)

func _input(event):
	if event.is_action_pressed("interact") and Game.inventory.active_item:
		Game.inventory.set_deferred("active_item", null)
		
		# 一个相对比较复杂的动画 放大再消失+透明改变+hid
		_hand_outro = create_tween()
		_hand_outro.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
		_hand_outro.tween_property(hand, "scale", Vector2.ONE * 3, 0.15)
		_hand_outro.tween_property(hand, "modulate:a", 0.0, 0.15)
		_hand_outro.chain().tween_callback(hand, 'hide')
	

func _update_ui(is_init:= false):
	var count = Game.inventory.get_item_count()
	
	prev.disabled = count < 2
	next.disabled = count < 2
	visible = count > 0
	
	var item := Game.inventory.get_current_item()
	if not item:
		return
	
	label.text = item.description
	prop.texture = item.prop_texture
	
	if is_init:
		return
	
	# 动画
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(prop, "scale", Vector2.ONE, 0.15).from(Vector2.ZERO)
	

func _show_label():
	if _label_outro and _label_outro.is_valid():
		_label_outro.kill()
		_label_outro = null
	label.show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, 'modulate:a', 1.0, 0.2)
	tween.tween_callback(timer, 'start')

func _on_Prev_pressed():
	Game.inventory.select_prev()
	_show_label()


func _on_Next_pressed():
	Game.inventory.select_next()
	_show_label()

func _on_Use_pressed():
	Game.inventory.active_item = Game.inventory.get_current_item()
	
	if _hand_outro and _hand_outro.is_valid():
		_hand_outro.kill()
		_hand_outro = null
	hand.show()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(hand, 'scale', Vector2.ONE, 0.15).from(Vector2.ZERO)
	tween.tween_property(hand, 'modulate:a', 1.0, 0.15)
	
	_show_label()
	
# 定时器结束之后 不展示这个文案了
func _on_Timer_timeout():
	_label_outro = create_tween()
	_label_outro.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_label_outro.tween_property(label, 'modulate:a', 0.0, 0.2)
	_label_outro.tween_callback(label, 'hide')
	pass # Replace with function body.
