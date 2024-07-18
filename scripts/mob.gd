extends RigidBody2D

@export var animation: AnimatedSprite2D
@export var collision: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types := animation.sprite_frames.get_animation_names()
	animation.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
