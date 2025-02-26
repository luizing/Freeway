extends Node

@export var pontuacao_maxima = 1
@export var tempo_maximo = 10

var cena_carros = preload("res://Cenas/carros.tscn")

var pistas_rapidas_y = [104, 272, 488]
var pistas_lentas_y = [160, 216, 324, 384, 438, 544, 600]
var pistas_invertidas_y = [160, 324, 388, 544]

var cronometro = 0

var score = 0

func reset() -> void:
	score = 0
	$HUD/Placar.text = str(score)
	$HUD/Mensagem.hide()
	$HUD/Button.hide()
	$AudioTema.play()


func _ready() -> void:
	reset()
	randomize()

func _on_timer_carros_rapidos_timeout() -> void:
	var carro = cena_carros.instantiate()
	add_child(carro)
	
	var pista_y = pistas_rapidas_y[randi_range(0, pistas_rapidas_y.size() - 1)]
	
	
	if pistas_invertidas_y.has(pista_y):
		carro.position = Vector2(-10, pista_y)
		carro.set_linear_velocity(Vector2(randf_range(700, 720), 0))

	else:
		carro.position = Vector2(+1300, pista_y)
		carro.set_linear_velocity(Vector2(randf_range(-650, -720), 0))
	
	carro.set_linear_damp(0.0)
	
func _on_timer_carros_lentos_timeout() -> void:
	var carro = cena_carros.instantiate()
	add_child(carro)
	
	var pista_y = pistas_lentas_y[randi_range(0, pistas_lentas_y.size() - 1)]
	
	carro.position = Vector2(-10, pista_y)
	carro.set_linear_velocity(Vector2(randf_range(300, 320), 0))
	carro.set_linear_damp(0.0)

func _on_player_pontua() -> void:	
	if score <= pontuacao_maxima:
		score += 1
		$HUD/Placar.text = str(score)
		$AudioPonto.play()
		$Player.position = $Player.posicao_inicial
	
	if score == pontuacao_maxima:
		$HUD/Placar.text = str(score)
		$HUD/Mensagem.text = "Parabens voce venceu"
		$HUD/Button.show()
		$AudioVitoria.play()
		
		$TimerCarrosLentos.stop()
		$TimerCarrosRapidos.stop()
		$AudioTema.stop()
		$Player.speed = 0
		
func _on_hud_reinicia() -> void:
	score = 0
	$HUD/Placar.text = str(score)
	$HUD/Mensagem.text = ""
	$HUD/Button.hide()
	$AudioTema.play()
	
	reset()
	$Player.speed = $Player.PlayerSpeed
	$TimerCarrosLentos.start()
	$TimerCarrosRapidos.start()


func _on_timer_game_over_timeout():
	cronometro += 1
	$LabelTimer.text = "Timer: " + str(cronometro)
	if cronometro == tempo_maximo:
		#GameOver
		reset()
		$Player.position = $Player.posicao_inicial
		cronometro = 0
		$LabelTimer.text = "TimeOut"
		
