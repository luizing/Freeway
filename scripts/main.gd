extends Node

@export var pontuacao_maxima = 1
@export var tempo_maximo = 10
@export var varVelocidadeRapida = Vector2(700,720)
@export var varVelocidadeLenta = Vector2(300,320)

var cena_carros = preload("res://Cenas/carros.tscn")

var pistas_y = [104, 160, 216, 272, 324, 384, 438, 488, 544, 600]

#Randomizar?
var pistas_rapidas_index = [0, 4, 6, 7]
var pistas_rapidas_y = []
var pistas_lentas_y = []
var pistas_invertidas_index = [1, 5, 7, 9]
var pistas_invertidas_y = []

var cronometro = 0
var score = 0

func reset() -> void:
	score = 0
	cronometro = 0
	$HUD/Mensagem.hide()
	$HUD/Button.hide()
	$LabelPlacar.text = str(score)
	
	$Player.reset()
	
	$TimerGameOver.start()
	$TimerCarrosLentos.start()
	$TimerCarrosRapidos.start()
	
func spawn_carro(pistas_lista: Array, velocidade_min: float, velocidade_max: float) -> void:
	var carro = cena_carros.instantiate()
	add_child(carro)
	
	var pista_y = pistas_lista[randi() % pistas_lista.size()]
	
	if pista_y in pistas_invertidas_y:
		carro.position = Vector2(+1300, pista_y)
		carro.set_linear_velocity(Vector2(randf_range(-velocidade_max, -velocidade_min), 0))
	else:
		carro.position = Vector2(-10, pista_y)
		carro.set_linear_velocity(Vector2(randf_range(velocidade_min, velocidade_max), 0))
	
	carro.set_linear_damp(0.0)

func setup_pistas() -> void:
	for index in range(pistas_y.size()):
		if pistas_rapidas_index.has(index):
			pistas_rapidas_y.append(pistas_y[index])
		else:
			pistas_lentas_y.append(pistas_y[index])
	
	for index in pistas_invertidas_index:
		if index >= 0 and index < pistas_y.size():
			pistas_invertidas_y.append(pistas_y[index])
	
func _ready() -> void:
	reset()
	setup_pistas()
	randomize()

func _on_timer_carros_rapidos_timeout() -> void:
	spawn_carro(pistas_rapidas_y, varVelocidadeRapida.x, varVelocidadeRapida.y)
	
func _on_timer_carros_lentos_timeout() -> void:
	spawn_carro(pistas_lentas_y, varVelocidadeLenta.x, varVelocidadeLenta.y)
	
func _on_player_pontua() -> void:	
	if score <= pontuacao_maxima:
		score += 1
		$LabelPlacar.text = str(score)
		$AudioPonto.play()
		$Player.position = $Player.posicao_inicial
	
	if score == pontuacao_maxima:
		$LabelPlacar.text = str(score)
		$HUD/Mensagem.text = "Parabens voce venceu"
		$TimerGameOver.stop()
		$HUD/Button.show()
		$AudioVitoria.play()
		
		$TimerCarrosLentos.stop()
		$TimerCarrosRapidos.stop()
		$AudioTema.stop()
		$Player.speed = 0
		
func _on_hud_reinicia() -> void:	
	$AudioTema.play()
	reset()

func _on_timer_game_over_timeout():
	cronometro += 1
	$LabelTimer.text = "Timer: " + str(cronometro)
	if cronometro == tempo_maximo:
		#GameOver
		$LabelTimer.text = "TimeOut"
		reset()

func _on_player_morre() -> void:
	reset()
	
