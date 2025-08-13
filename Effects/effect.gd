extends AnimatedSprite2D

var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	position += velocity * delta

func _ready():
	self.animation_finished.connect(_on_animation_finished)
	play("Animate")

func _on_animation_finished():
	queue_free()
