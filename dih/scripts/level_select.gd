extends Control
const LEVEL1_SCENE = preload("res://scenes/stadium1.tscn")
const PLACEHOLDER_SCREEN = preload("res://scenes/place_holder_scene.tscn")




func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL1_SCENE)


func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_packed(PLACEHOLDER_SCREEN)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_packed(PLACEHOLDER_SCREEN)
