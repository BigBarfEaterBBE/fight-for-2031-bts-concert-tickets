extends Node

@onready var timer = $timer
@onready var time_label = $Label

var total_available_seats = 5
var seats_selected = 0
var game_running = false
var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_all_seats()
	if total_available_seats > 0:
		timer.start()
		game_running = true

func connect_all_seats():
	var seats_in_scene = get_tree().get_nodes_in_group("seats")
	total_available_seats = seats_in_scene.size()
	for seat in seats_in_scene:
		if seat.has_signal("selected_seat"):
			seat.selected_seat.connect(on_seat_selected)

func on_seat_selected():
	seats_selected += 1
	if seats_selected >= total_available_seats:
		game_won()

func game_won():
	if game_running:
		timer.stop()
		game_running = false
		var final_time = time_label.text.split(":")[-1].strip_edges()
		time_label.text = "Time: " + final_time
		#add a victory screen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		elapsed_time += delta
		time_label.text = "Time: " + str(snapped(elapsed_time, 0.01))
