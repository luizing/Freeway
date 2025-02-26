extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tipo_carros = $Animacao.sprite_frames.get_animation_names()
	var carro = tipo_carros[randi_range(0,tipo_carros.size() - 1 )]
	$Animacao.animation = carro

func _on_noticador_screen_exited() -> void:
	queue_free()
