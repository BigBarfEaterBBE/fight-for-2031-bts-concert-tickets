extends Node
@export var seat_scene = "res://scenes/seat.tscn"
@onready var map_sprite: Sprite2D = $map

const AVAILABLE_COLOR = Color(42, 85, 217, 1)
func _ready():
	generate_seats()

func generate_seats():
	if map_sprite.texture == null:
		return
	var texture: Texture2D = map_sprite.texture
	var image_data: Image = texture.get_image()
	var sprite_global_pos = map_sprite.global_position
	var pixel_step = 8
	for x in range(0, image_data.get_width(), pixel_step):
		for y in range(0, image_data.get_height(), pixel_step):
			var pixel_color = image_data.get_pixel(x,y)
			if pixel_color.is_equal_approx(AVAILABLE_COLOR):
				var seat_position = Vector2(x,y) + sprite_global_pos
				create_seat_instance(seat_position)
	
func create_seat_instance(position: Vector2):
	var new_seat = seat_scene.instantiate()
	new_seat.position = position
	add_child(new_seat)
