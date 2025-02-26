extends Area2D

signal pontua
signal morre

@export var PlayerSpeed: float = 500.0
var speed = PlayerSpeed

var screen_size: Vector2

var posicao_inicial: Vector2 = Vector2(640, 690)

func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = posicao_inicial
	
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	#Controles
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.y = clamp(position.y, 0.0, screen_size.y)
	position.x = clamp(position.x, 0.0, screen_size.x)

	if velocity.y > 0:
		$Animacao.play("baixo")
	elif velocity.y < 0:
		$Animacao.play("cima")
	else:
		$Animacao.stop()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "LinhaChegada":
		emit_signal("pontua")
	else:
		emit_signal("morre")
		$AudioMorte.play()
		
func reset() -> void:
	position = posicao_inicial
	speed = PlayerSpeed
	
	
