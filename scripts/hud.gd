extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

@onready var message: Label = $Message
@onready var scoreLabel: Label = $ScoreLabel
@onready var startButton: Button = $StartButton
@onready var messageTimer: Timer = $MessageTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _on_start_button_pressed():
	startButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	message.hide()


func show_message(text) -> void:
	message.text = text
	message.show()
	messageTimer.start()


func show_game_over() -> void:
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await messageTimer.timeout

	message.text = "Dodge the Creeps!"
	message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	startButton.show()


func update_score(score: int) -> void:
	scoreLabel.text = str(score)
