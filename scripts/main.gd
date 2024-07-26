extends Node

@export var mob_scene: PackedScene
@onready var powerup_manager = %PowerupManager
@onready var score_manager = %ScoreManager
@onready var HUD: CanvasLayer = $HUD
@onready var player: Area2D = $Player
@onready var start_position: Marker2D = $StartPosition
@onready var start_timer: Timer = $Timers/StartTimer
@onready var mob_timer: Timer = $Timers/MobTimer
@onready var death_sound: AudioStreamPlayer = $DeathSound


func new_game():
	HUD.update_score(0)
	HUD.show_message("Get Ready")
	player.start(start_position.position)
	start_timer.start()


func _game_over():
	score_manager.stop()
	mob_timer.stop()
	powerup_manager.stopTimers()
	death_sound.play()
	HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")


func _on_start_timer_timeout():
	mob_timer.start()
	score_manager.start()
	powerup_manager.startTimers()


func _on_score_manager_score_updated(new_score):
	HUD.update_score(new_score)


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_powerup_manager_score_powerup_triggered():
	score_manager.update_score(5)
