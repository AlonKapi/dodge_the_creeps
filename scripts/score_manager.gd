extends Node


@onready var score_timer = $ScoreTimer
signal score_updated(new_score: int)
var score: int:
	get:
		return score
	set(value):
		print('score updated ' + str(value))
		score = value
		score_updated.emit(score)


func _on_score_timer_timeout():
	score += 1


func start():
	score = 0
	score_timer.start()


func stop():
	score = 0
	score_timer.stop()


func update_score(value):
	score += value
