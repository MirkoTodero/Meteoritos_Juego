extends Node2D

class_name EstacionRecarga

export var energia:float = 20.0
export var radio_energia_entregada:float = 0.5

onready var carga_sfx:AudioStreamPlayer = $CargaSFX
onready var barra_energia:ProgressBar = $BarraEnegia

var nave_player:Jugador = null
var player_en_zona:bool = false

func _ready()->void:
	barra_energia.max_value = energia
	barra_energia.value = energia

func _unhandled_input(event:InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	controlar_energia()
	
	if event.is_action("recargar_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action("recargar_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)
	
	if event.is_action_released("recargar_laser"):
		Eventos.emit_signal("ocultar_energia_laser")
	if event.is_action_released("recargar_escudo"):
		Eventos.emit_signal("ocultar_energia_escudo")

func _on_AreaEstacion_body_entered(body:Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_AreaRecarga_body_entered(body:Node) -> void:
	if body is Jugador:
		player_en_zona = true
		nave_player = body
		Eventos.emit_signal("detecto_zona_recarga", true)

func _on_AreaRecarga_body_exited(body:Node) -> void:
	player_en_zona = false
	carga_sfx.stop()
	Eventos.emit_signal("detecto_zona_recarga", false)

func puede_recargar(event:InputEvent) -> bool:
	var hay_input = event.is_action("recargar_escudo") or event.is_action("recargar_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
			carga_sfx.play()
		return true
		
	return false

func controlar_energia() -> void:
	energia -= radio_energia_entregada
	if energia <= 0.0:
		$VacioSFX.play()
	barra_energia.value = energia
