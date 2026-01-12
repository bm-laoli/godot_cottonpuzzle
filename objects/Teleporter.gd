tool
extends Interactable
class_name Teleporter

export(String, FILE, "*.tscn") var target_path: String

func _interact():
	._interact()
	SceneChanger.change_scene(target_path)
