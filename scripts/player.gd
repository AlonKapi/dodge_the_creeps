extends Area2D

signal hit

@export var animation: AnimatedSprite2D
@export var collision: CollisionShape2D
@export var speed := 400 # How fast the player will move (pixels/sec).
var screen_size: Vector2 # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity := Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # Preventing fast movement during diagonal movement
		animation.play()
	else:
		animation.stop()
		
	position += velocity * delta # Changing the player position based on the calculated velocity
	position = position.clamp(Vector2.ZERO, screen_size) # Clamping a value means restricting it to a given range, to prevent it from leaving the screen
	
	if velocity.x != 0 and velocity.y != 0:
		animation.animation = "up"
		animation.flip_v = velocity.y > 0
	elif velocity.x != 0:
		animation.animation = "walk"
		animation.flip_v = false
		animation.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animation.animation = "up"
		animation.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	collision.set_deferred("disabled", true)


func start(pos: Vector2):
	position = pos
	show()
	collision.disabled = false
