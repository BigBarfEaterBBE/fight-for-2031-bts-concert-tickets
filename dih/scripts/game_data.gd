extends Node

var level_scores = {
	"Level1": -1.0#,
	#"Level2": -1.0
}
var levels = {
	"Level1": {
		"best": 8.0,
		"okay": 11.0,
		"worst": 14.0
	}
}
var level2_unlocked = false
func record_fast_time(level_name: String, time:float):
	if level_scores[level_name] == -1.0 or time < level_scores[level_name]:
		level_scores[level_name] = time
	'''
	if level_name == "Level1":
		level2_unlocked = true 

func get_level_unlocked(level_name: String) -> bool:
	if level_name == "Level2":
		return level2_unlocked
	return true '''
