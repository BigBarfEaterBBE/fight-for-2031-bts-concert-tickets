extends Area2D
signal selected_seat
@onready var seat_visual = $ColorRect
@onready var collision_shape = $CollisionShape2D
var available_color = Color.html("#2a55d9")
var selected_color = Color.html("c8c8c8")
var is_available = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	
	if is_instance_valid(seat_visual):
		if seat_visual.material:
			seat_visual.material = seat_visual.material.duplicate()
		seat_visual.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		_change_material_color(selected_color)
		is_available = false
		if is_instance_valid(collision_shape):
			collision_shape.set_deferred("disabled", true)
		
func _input_event(_viewport:Node, event:InputEvent, shape_idx:int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("CLICKED")
		if is_available:
			is_available = false
			if _change_material_color(selected_color):
				print("color changed success")
			else:
				print("color change failed")
			collision_shape.set_deferred("disabled", true)
			emit_signal("selected_seat")

func make_available():
	if is_instance_valid(seat_visual):
		_change_material_color(available_color)
		is_available = true
		if is_instance_valid(collision_shape):
			collision_shape.set_deferred("disabled", false)

func _change_material_color(new_color: Color) -> bool:
	if not is_instance_valid(seat_visual) or seat_visual.material == null:
		print("NO VALID MAT FOUND")
		return false
	var material = seat_visual.material
	material.set_shader_parameter("color", new_color)
	return true
	
