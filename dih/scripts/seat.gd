extends Area2D
signal selected_seat
@onready var seat_visual = $ColorRect
@onready var collision_shape = $CollisionShape2D
var available_color = Color.html("#2a55d9")
var selected_color = Color.html("c8c8c8")
var is_available = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seat_visual.color = available_color
		
func _input_event(viewport:Node, event:InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_available:
			is_available = false
			seat_visual.color = selected_color
			collision_shape.set_deferred("disabled", true)
			emit_signal("selected_seat")
			get_tree().create_timer(0.1).timeout.connect(func():queue_free())
		get_tree().set_input_as_handled()
				
