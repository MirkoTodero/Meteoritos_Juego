extends Node2D

export var hitpoints:float = 30.0
export var orbital:PackedScene = null

onready var impacto_sfx:AudioStreamPlayer2D = $Impactos

var esta_destruido:bool = false

func _process(delta:float) -> void:
	var jugador_objetivo:Jugador = DatosJuego.get_jugador_actual()
	if not jugador_objetivo:
		return
	
	var dir_jugador:Vector2 = jugador_objetivo.global_position - global_position
	var angulo_jugador:float = rad2deg(dir_jugador.angle())

func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())

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
	queue_free()
	Eventos.emit_signal("base_destruida", self, posicion_partes)

func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	spawnear_orbital()

func spawnear_orbital() -> void:
	var pos_spawn:Vector2 = deteccion_cuadrante()
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + pos_spawn,
		self
	)
	Eventos.emit_signal("spawn_orbital", new_orbital)

func deteccion_cuadrante() -> Vector2:
	var jugador_objetivo:Jugador = DatosJuego.get_jugador_actual()
	
	if not jugador_objetivo:
		return Vector2.ZERO
	
	var dir_jugador:Vector2 = jugador_objetivo.global_position - global_position
	var angulo_jugador:float = rad2deg(dir_jugador.angle())
	
	if abs(angulo_jugador) <= 45.0:
		return $PosicionesSpawn/Este.position
	elif abs(angulo_jugador) > 135.0 and abs(angulo_jugador) <= 180.0:
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_jugador) > 45.0 and abs(angulo_jugador) <= 135.0:
		if sign(angulo_jugador) > 0:
			return $PosicionesSpawn/Sur.position
		else:
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position
