extends Node

@onready var timer = $timer
@onready var time_label = $Label
@onready var seat_container = $SeatContainer
@onready var countdown_timer = $CountdownTimer
@onready var countdown_label = $CenterContainer/CountdownLabel
@onready var return_button = $TextureRect
@onready var return_label = $Label2
@onready var stars = {
	"star1": $TextureRect2,
	"star2": $TextureRect3,
	"star3": $TextureRect4
}
@onready var anim_players = {
	"star1": $TextureRect2/AnimationPlayer,
	"star2": $TextureRect3/AnimationPlayer,
	"star3": $TextureRect4/AnimationPlayer
}
const TARGET_SEAT_COUNT = 7

var total_available_seats = 0
var seats_selected = 0
var game_running = false
var elapsed_time = 0.0
var countdown_time: int = 3
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	return_button.disabled = true
	return_button.hide()
	return_label.hide()
	start_countdown()

func change_return_button_visibility():
	return_button.disabled = false
	return_button.show()
	return_label.show()

func start_countdown():
	time_label.hide()
	countdown_label.show()
	countdown_label.text = str(3)
	countdown_timer.start()

func _on_countdown_timer_timeout():
	countdown_time -= 1
	if countdown_time > 0:
		countdown_label.text = str(countdown_time)
	elif countdown_time == 0:
		countdown_label.text = "START!"
	else:
		countdown_timer.stop()
		start_game()

func start_game():
	connect_all_seats()
	countdown_label.hide()
	time_label.show()
	timer.start()
	game_running = true
	time_label.text = "Time: 0.00"

func connect_all_seats():
	# ❗ FIX 1 & 2: Initialize array and remove unnecessary grouping
	var all_seats: Array = []
	
	if is_instance_valid(seat_container):
		for seat in seat_container.get_children():
			# Only consider nodes that are actual seat instances (Area2D)
			if seat is Area2D:
				all_seats.append(seat)
	else:
		printerr("CRITICAL ERROR: SeatContainer node not found or invalid.")
		return
		
	# 3. Shuffle all seats to pick random ones
	all_seats.shuffle()
	
	# Select the target number of seats to make available
	var available_seats = all_seats.slice(0, TARGET_SEAT_COUNT)
	total_available_seats = available_seats.size() 
	
	# 4. Make the selected seats available AND connect their signals
	for seat in available_seats:
		# A. Make the seat clickable/blue
		if seat.has_method("make_available"):
			seat.make_available()
		else:
			print("Seat does not have make_available method")
			
		# B. Connect the seat's signal to this manager
		if seat.has_signal("selected_seat"):
			seat.selected_seat.connect(on_seat_selected)
		else:
			print("Seat does not have selected_seat signal")

func on_seat_selected():
	seats_selected += 1
	if seats_selected >= total_available_seats:
		game_won()

func game_won():
	if game_running:
		timer.stop() # Stops the Timer node
		game_running = false # Stops the _process() loop from running
		if elapsed_time < GameData.levels["Level1"]["best"]:
			star_animation(3)
		elif elapsed_time < GameData.levels["Level1"]["okay"]:
			star_animation(2)
		elif elapsed_time < GameData.levels["Level1"]["worst"]:
			star_animation(1)
				
		GameData.record_fast_time("Level1",elapsed_time)
		# Display final result using the clean elapsed_time variable
		var final_time_string = str(snapped(elapsed_time, 0.01))
		time_label.text = "FINISHED! Time: " + final_time_string
		time_label.hide()
		countdown_label.text = "FINISHED! \n TIME: " + final_time_string
		countdown_label.show()
		change_return_button_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		elapsed_time += delta
		
		# Display current time and score (THIS IS THE KEY LINE)
		time_label.text = "Time: " + str(snapped(elapsed_time, 0.01))


func _on_texture_rect_pressed() -> void:
	var level_select_path = "res://scenes/level_select.tscn"
	var level_select_scene = load(level_select_path)
	
	if level_select_scene:
		# Use call_deferred to safely change the scene.
		get_tree().call_deferred("change_scene_to_packed", level_select_scene)

func animate_star(star_node: TextureRect, anim_player: AnimationPlayer):
	star_node.show()
	if anim_player.has_animation("pop"):
		anim_player.play("pop")

func star_animation(star_number: int):
	var delay = 0.7
	for i in range(1, star_number + 1):
		var star_key = "star" + str(i)
		var star = stars[star_key]
		star.show()
		animate_star(star, anim_players[star_key])
		await get_tree().create_timer(delay).timeout
		
		
