@tool
extends Node

@onready var map = $map
var map_texture = map.texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		#for x in viewport.width():
			#for y in viewport.height():
				pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
