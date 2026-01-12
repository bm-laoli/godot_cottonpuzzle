extends Sprite
class_name Scene

export(String , FILE, "*.mp3") var music_override := ""

func _ready():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'scale', Vector2.ONE, 0.3).from(Vector2.ONE * 1.05)
	pass

