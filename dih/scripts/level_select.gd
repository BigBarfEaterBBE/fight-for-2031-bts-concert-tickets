extends Control
const LEVEL1_SCENE = preload("res://scenes/stadium1.tscn")
const TITLESCREEN_SCENE = preload("res://scenes/title_screen.tscn")
const PLACEHOLDER_SCREEN = preload("res://scenes/place_holder_scene.tscn")



func _on_level_1_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", LEVEL1_SCENE)


func _on_level_2_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", PLACEHOLDER_SCREEN)


func _on_return_button_pressed() -> void:
	var main_scene_path = ProjectSettings.get_setting("application/run/main_scene")
	
	if main_scene_path.is_empty():
		printerr("CRITICAL ERROR: Main scene path is empty. Check Project Settings.")
		return
		
	# Load the scene resource using the retrieved path
	var main_scene_resource = load(main_scene_path)
	
	if main_scene_resource:
		# Use call_deferred to safely change the scene.
		get_tree().call_deferred("change_scene_to_packed", main_scene_resource)
	else:
		printerr("CRITICAL ERROR: Failed to load Main Scene from path: ", main_scene_path, 
				 ". Verify the scene file exists and is not corrupt.")
