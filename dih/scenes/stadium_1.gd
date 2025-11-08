extends Node

@onready var timer = $timer
@onready var time_label = $Label

var total_available_seats = 5
var seats_selected = 0
var game_running = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if total_available_seats > 0:
		timer.start()
		game_running = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
