extends Node

@onready var timer = $timer
@onready var time_label = $Label
@onready var seat_container = $SeatContainer
const TARGET_SEAT_COUNT = 7

var total_available_seats = 0
var seats_selected = 0
var game_running = false
var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	connect_all_seats()
	if total_available_seats > 0:
		timer.start()
		game_running = true
	else:
		time_label.text = "ERROR: NOT ENOUGH SEATS"
		

func connect_all_seats():
	var all_seats
	if is_instance_valid(seat_container):
		var count = 0
		for seat in seat_container.get_children():
			if seat is Area2D:
				seat.add_to_group("seats")
				count += 1
		all_seats = get_tree().get_nodes_in_group("seats")
	all_seats.shuffle()
	var available_seats = all_seats.slice(0,TARGET_SEAT_COUNT)
	total_available_seats = TARGET_SEAT_COUNT
	for seat in available_seats:
		if seat.has_method("make_available"):
			seat.make_available()
		else:
			print("Seat does not have method")
	for seat in all_seats:
		if seat.has_signal("selected_seat"):
			seat.selected_seat.connect(on_seat_selected)
		else:
			print("seat does not have signal")

func on_seat_selected():
	seats_selected += 1
	if seats_selected >= total_available_seats:
		game_won()

func game_won():
	if game_running:
		timer.stop() # Stops the Timer node
		game_running = false # Stops the _process() loop from running
		
		# Display final result using the clean elapsed_time variable
		var final_time_string = str(snapped(elapsed_time, 0.01))
		time_label.text = "FINISHED! Time: " + final_time_string
		print("VICTORY! Final Time: ", final_time_string)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		elapsed_time += delta
		
		# Display current time and score (THIS IS THE KEY LINE)
		time_label.text = "Time: " + str(snapped(elapsed_time, 0.01)) + " | Found: " + str(seats_selected)
