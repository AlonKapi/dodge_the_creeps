extends Node

@export var mob_scene: PackedScene
@onready var HUD: CanvasLayer = $HUD
@onready var player: Area2D = $Player
@onready var start_position: Marker2D = $StartPosition
@onready var start_timer: Timer = $Timers/StartTimer
@onready var score_timer: Timer = $Timers/ScoreTimer
@onready var mob_timer: Timer = $Timers/MobTimer
@onready var death_sound: AudioStreamPlayer = $DeathSound
var score: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _game_over():
	death_sound.play()
	HUD.show_game_over()
	score_timer.stop()
	mob_timer.stop()


func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	HUD.update_score(score)
	HUD.show_message("Get Ready")
	player.start(start_position.position)
	start_timer.start()


func _on_start_timer_timeout():
	mob_timer.start()
	score_timer.start()


func _on_score_timer_timeout():
	score += 1
	HUD.update_score(score)


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

