extends CanvasLayer


func _on_TextureButton_pressed():
	Game.back_to_title()

func _ready():
	SceneChanger.connect("game_entered",self, 'show')
	SceneChanger.connect("game_exited",self, 'hide')
	
	visible = get_tree().current_scene is Scene
	
