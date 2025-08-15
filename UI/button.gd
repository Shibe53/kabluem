extends Button

const HOVER_RISE = -15
const ANIM_TIME = 0.3
const PRESS_ROTATION = 10
const PRESS_ANIM_TIME = 0.5

var original_position : Vector2

func _ready():
	self.focus_mode = Control.FOCUS_NONE
	original_position = position
	rotation_degrees = 0
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("button_down", Callable(self, "_on_pressed"))
	connect("button_up", Callable(self, "_on_released"))

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_position.y + HOVER_RISE, ANIM_TIME).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_position.y, ANIM_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_pressed():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", PRESS_ROTATION, PRESS_ANIM_TIME).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_released():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, PRESS_ANIM_TIME).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
