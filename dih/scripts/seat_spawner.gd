@tool
extends Node

# ==============================================================================
# ⚠️ CONFIGURATION - YOU MUST EDIT THESE VALUES ⚠️
# ==============================================================================

const ARENA_PATH = "res://assets/agganis_arena.png" # 1. Path to your arena image asset
const SEAT_COLORS = [ # 2. The exact colors of the seats in the blueprint image.
	"e162a6",
	"2f59da",
	"f0b1d3",
	"ececec"
]
const SEAT_SCENE = preload("res://scenes/seat.tscn")
const SCALE_FACTOR = 0.3 # 4. Scale factor to resize the spawned Seat.tscn

# ==============================================================================
# ❗ ADJUSTABLE EDITOR SETTINGS
# ==============================================================================
@export_range(1, 20) var pixel_skip: int = 10
@export_range(1, 500) var batch_size: int = 50 # LOWERED BATCH SIZE FOR STABILITY
@export var run_spawner: bool = false: set = set_run_spawner

# Custom setter function that runs when the export variable is changed (clicked)
func set_run_spawner(value: bool):
	run_spawner = value
	if Engine.is_editor_hint():
		notify_property_list_changed() 
		
	if run_spawner:
		# Call the ASYNC heavy logic only when the box is checked
		_spawn_seats()
		run_spawner = false # Turn the box off after running

# Helper function to add a child in a way that is visible to the editor
func _add_child_in_editor(child: Node):
	if Engine.is_editor_hint():
		# The 'true' flag ensures the node is added for saving
		add_child(child, true) 
	else:
		add_child(child)

# ❗ NEW FUNCTION: Robust cleanup using remove_child/free for the editor
func cleanup_existing_seats():
	var deleted_count = 0
	var children_to_delete = []
	for child in get_children():
		if child is Area2D:
			children_to_delete.append(child)

	# Safely delete them immediately in the editor
	for node in children_to_delete:
		remove_child(node)
		node.free()
		deleted_count += 1
	
	print("DEBUG: Deleted ", deleted_count, " old seat nodes.")

# ❗ MAIN SPAWNING LOGIC (now asynchronous for crash prevention)
func _spawn_seats():
	print("--- Running Seat Spawner Tool ---")
	
	cleanup_existing_seats()
	
	# --- Validation ---
	if not FileAccess.file_exists(ARENA_PATH):
		printerr("ERROR: Arena image not found at path: ", ARENA_PATH)
		return
	if SEAT_SCENE == null:
		printerr("ERROR: Seat scene not preloaded. Check path: ", SEAT_SCENE.resource_path)
		return
		
	# --------------------------------------------------------------------------
	# Load Image
	# --------------------------------------------------------------------------
	var image = Image.load_from_file(ARENA_PATH)
	
	if image.is_empty():
		printerr("CRITICAL ERROR: Image failed to load or is empty. Check resource settings.")
		return
		
	# ❗ CRITICAL OWNER FIX: Get the scene root once. We try ancestor first for robustness.
	var scene_root: Node = get_tree().get_edited_scene_root()
	# If the root is null (which can happen during complex operations), find the best ancestor.
	if scene_root == null:
		scene_root = get_parent()
		if scene_root == null:
			printerr("CRITICAL ERROR: Could not find any suitable ancestor. Cannot save spawned nodes.")
			return
	
	# ❗ CENTERING FIX: Calculate the offset needed to center the seat.
	# We assume the pixel_skip is the approximate size of one seat area.
	var spawn_offset = Vector2(pixel_skip / 2.0, pixel_skip / 2.0)
	

	var spawned_count = 0
	var batch_counter = 0
	
	# --------------------------------------------------------------------------
	# Scan Pixels and Spawn Seats (Batching Implemented)
	# --------------------------------------------------------------------------
	for y in range(0, image.get_height()):
		for x in range(0, image.get_width()):
			var pixel_color = image.get_pixel(x,y)
			
			if is_seat_color(pixel_color) and pixel_color.a > 0.9:
				
				spawned_count += 1
				batch_counter += 1
				var new_seat = SEAT_SCENE.instantiate()
				
				# FINAL OWNER ASSIGNMENT: Use the validated scene root/ancestor
				new_seat.owner = scene_root 
				
				new_seat.scale = Vector2(SCALE_FACTOR, SCALE_FACTOR)
				
				# ❗ CENTERING APPLICATION: Move the position to the center of the pixel area.
				new_seat.global_position = Vector2(x,y) + spawn_offset
				
				_add_child_in_editor(new_seat)
				
				# Skip forward to prevent spawning a seat for every pixel of one seat
				x += pixel_skip - 1 
				
				# ❗ YIELDING: Pause the script after spawning a batch of seats
				if batch_counter >= batch_size:
					# This yields control back to the editor for one frame, preventing a crash.
					await get_tree().process_frame
					batch_counter = 0


	print("SUCCESS: Spawning completed. Total seats spawned: ", spawned_count)
	print("--- Spawner Tool Finished ---")
	
	if get_tree().get_edited_scene_root():
		print("--- ACTION REQUIRED: SAVE SCENE NOW (Ctrl+S or Cmd+S) ---")
		

func is_seat_color(color: Color) -> bool:
	"""Checks if the given pixel color is close to any of the defined seat colors."""
	for seat_color_hex in SEAT_COLORS:
		# Convert hex string to Color object for comparison
		if color.is_equal_approx(Color.html(seat_color_hex)): 
			return true
	return false

func _ready() -> void:
	if not Engine.is_editor_hint():
		pass
