extends NaveBase

class_name EnemigoBase

var jugador_objetivo:Jugador = null
var dir_jugador:Vector2
var frame_actual:int = 0

func _ready() -> void:
	jugador_objetivo = DatosJuego.get_jugador_actual()
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func _physics_process(_delta: float) -> void:
	frame_actual += 1
	if frame_actual % 3 == 0:
		rotar_hacia_jugador()

func _on_nave_destruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Jugador:
		jugador_objetivo = null
	if nave.is_in_group("minimap"):
		Eventos.emit_signal("minimapa_objeto_destruido", nave)

func rotar_hacia_jugador() -> void:
	if jugador_objetivo:
		dir_jugador = jugador_objetivo.global_position - global_position
		rotation = dir_jugador.angle()

func _on_body_entered(body:Node) -> void:
	._on_body_entered(body)
	if body is Jugador:
		body.destruir()
		destruir()
