extends CanvasLayer
signal reinicia

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	emit_signal("reinicia")
