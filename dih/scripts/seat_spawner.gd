@tool
extends Node
const ARENA_PATH = "res://assets/agganis_arena.png"
const SEAT_COLORS = [
	"e162a6",
	"2f59da",
	"f0b1d3",
	"ececec"
]
const PIXEL_SKIP = 2
const SEAT_SCENE = preload("res://scenes/seat.tscn")
const SCALE_FACTOR = 0.3

func _add_child_in_editor(child: Node):
	if Engine.is_editor_hint():
		add_child(child, true)
	else:
		add_child(child)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	print("running seat spawner tool")
	if not FileAccess.file_exists(ARENA_PATH):
		print("arena img not found")
		return
	if SEAT_SCENE == null:
		print("seat scene not preloaded")
		return
	var image = Image.load_from_file(ARENA_PATH)
	var spawned_count = 0
	var scene_root = get_tree().get_edited_scene_root()
	for y in range(0, image.get_height()):
		for x in range(0, image.get_width()):
			var pixel_color = image.get_pixel(x,y)
			if is_seat_color(pixel_color):
				if get_child_at_position(Vector2(x,y)):
					continue
				spawned_count += 1
				var new_seat = SEAT_SCENE.instantiate()
				new_seat.scale = Vector2(SCALE_FACTOR, SCALE_FACTOR)
				new_seat.global_position = Vector2(x,y)
				_add_child_in_editor(new_seat)
				x += PIXEL_SKIP - 1
	print("finished")
	if scene_root:
		var scene_path = scene_root.get_path()
		if scene_path.ends_with(".tcsn"):
			ResourceSaver.save(scene_root,scene_path)
			print("scene saved successfully")
		else:
			print("scene saving error")
		

func is_seat_color(color: Color) -> bool:
	for seat_color in SEAT_COLORS:
		if color.is_equal_approx(Color.html(seat_color)):
			return true
	return false

func get_child_at_position(position: Vector2) -> bool:
	for child in get_children():
		if child is Area2D and child.global_position.is_equal_approx(position):
			return true
	return false
