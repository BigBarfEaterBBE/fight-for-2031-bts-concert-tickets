extends Control
const LEVELSELECT_SCENE = preload("res://scenes/level_select.tscn")



func _on_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", LEVELSELECT_SCENE)
