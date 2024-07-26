extends Node


@onready var powerup_timers = [$ScorePowerupTimer]
signal score_powerup_triggered

func _on_score_powerup_timeout():
	print("spawn a powerup")
	var powerup: Powerup = Powerup.new_powerup(Powerup.POWERUP_TYPE.SCORE)
	add_child(powerup)


func startTimers():
	for timer in powerup_timers:
		timer.start()


func stopTimers():
	for timer in powerup_timers:
		timer.stop()


func trigger_powerup(type: Powerup.POWERUP_TYPE):
	match type:
		Powerup.POWERUP_TYPE.SCORE:
			score_powerup_triggered.emit()
