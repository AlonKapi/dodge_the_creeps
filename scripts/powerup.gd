class_name Powerup
extends Area2D

const scene: PackedScene = preload("res://scenes/powerup.tscn")

@onready var sprite = $Sprite2D
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var collision_shape = $CollisionShape2D
@onready var powerup_sound = $PowerupSound
@onready var expires_timer = $ExpiresTimer
@onready var remove_timer = $RemoveTimer

enum POWERUP_TYPE { SCORE }
var type: POWERUP_TYPE


static func new_powerup(new_powerup_type: POWERUP_TYPE):
	var powerup: Powerup = scene.instantiate()
	powerup.type = new_powerup_type
	return powerup


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("active")
	var screen_size: Vector2 = get_viewport_rect().size
	var x: float = randf_range(20, screen_size.x - 20)
	var y: float = randf_range(20, screen_size.y - 20)
	position = Vector2(x, y)


func _on_expires_timer_timeout():
	animation_player.play("expires")


func _on_remove_timer_timeout():
	remove()


func _on_area_entered(area):
	print("body entered powerup")
	powerup_effect()


func powerup_effect():
	powerup_sound.play()
	remove()
	print("add 10 points")


func remove():
	expires_timer.stop()
	remove_timer.stop()
	collision_shape.disabled = true
	sprite.hide()
	await get_tree().create_timer(1.0).timeout
	queue_free()

