@tool
extends Node 

# --- WARNING: Only run this script once, then delete it or turn it off! ---
# This script is marked @tool, so it runs inside the Godot Editor.
# It automatically groups all children nodes of the parent it is attached to.

const SEAT_GROUP_NAME = "seats"

# The _ready function runs automatically when the scene loads (in the game)
# and when the scene is opened (in the editor) because of @tool.
func _ready():
	# Only run the grouping logic in the editor, not during the actual game runtime.
	if Engine.is_editor_hint():
		print("--- Running Seat Grouping Tool ---")
		var grouped_count = 0
		
		# Loop through every child node (i.e., every individual seat)
		for seat in get_children():
			# Check if the child is a scene we want to group (e.g., is it an Area2D?)
			if seat is Area2D:
				# Add the node to the specified group
				if not seat.is_in_group(SEAT_GROUP_NAME):
					seat.add_to_group(SEAT_GROUP_NAME)
					grouped_count += 1
				
		print("SUCCESS: Added ", grouped_count, " seats to the '", SEAT_GROUP_NAME, "' group.")
		print("--- Grouping Complete. Safe to detach script. ---")
		
		# Optional: You can queue_free() the script itself to remove it after use
		# self.queue_free()
