extends Node2D

class_name BaseEnemiga

export var hitpoints:float = 30.0
export var orbital:PackedScene = null
export var numero_orbitales:int = 10.0
export var intervalo_spawn:float = 0.8
export(Array, PackedScene) var rutas

onready var impacto_sfx:AudioStreamPlayer2D = $Impactos
onready var timer_spawner:Timer = $TimerSpawnerEnemigos
onready var barra_salud:ProgressBar = $BarraSalud

var esta_destruido:bool = false
var posicion_spawn:Vector2 = Vector2.ZERO
var ruta_seleccionada:Path2D

func _process(delta:float) -> void:
	var jugador_objetivo:Jugador = DatosJuego.get_jugador_actual()
	if not jugador_objetivo:
		return
	
	var dir_jugador:Vector2 = jugador_objetivo.global_position - global_position
	var angulo_jugador:float = rad2deg(dir_jugador.angle())

func _ready() -> void:
	timer_spawner.wait_time = intervalo_spawn
	$AnimationPlayer.play(elegir_animacion_aleatoria())
	seleccionar_ruta()
	barra_salud.set_valores(hitpoints)

func seleccionar_ruta() -> void:
	randomize()
	var indice_ruta:int = randi() % rutas.size() - 1
	ruta_seleccionada = rutas[indice_ruta].instance()
	add_child(ruta_seleccionada)

func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	
	if hitpoints < 0 and not esta_destruido:
		esta_destruido = true
		destruir()
	
	barra_salud.set_hitpoints_actual(hitpoints)
	impacto_sfx.play()

func _on_AreaColision_body_entered(body:Node) -> void:
	body.destruir()

func destruir() -> void:
	var posicion_partes = [
		$Sprites/Sprite1.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite4.global_position,
		$Sprites/Sprite5.global_position,
		$Sprites/Sprite6.global_position,
		
	]
	Eventos.emit_signal("base_destruida", self, posicion_partes)
	Eventos.emit_signal("minimapa_objeto_destruido", self)
	queue_free()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = deteccion_cuadrante()
	spawnear_orbital()
	timer_spawner.start()

func spawnear_orbital() -> void:
	numero_orbitales -= 1
	ruta_seleccionada.global_position = global_position
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + posicion_spawn,
		self,
		ruta_seleccionada
	)
	Eventos.emit_signal("spawn_orbital", new_orbital)

func deteccion_cuadrante() -> Vector2:
	var jugador_objetivo:Jugador = DatosJuego.get_jugador_actual()
	
	if not jugador_objetivo:
		return Vector2.ZERO
	
	var dir_jugador:Vector2 = jugador_objetivo.global_position - global_position
	var angulo_jugador:float = rad2deg(dir_jugador.angle())
	
	if abs(angulo_jugador) <= 45.0:
		ruta_seleccionada.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_jugador) > 135.0 and abs(angulo_jugador) <= 180.0:
		ruta_seleccionada.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_jugador) > 45.0 and abs(angulo_jugador) <= 135.0:
		if sign(angulo_jugador) > 0:
			ruta_seleccionada.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			ruta_seleccionada.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position

func _on_TimerSpawnerEnemigos_timeout():
	if numero_orbitales == 0:
		timer_spawner.stop()
		return
	spawnear_orbital()
