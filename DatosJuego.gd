extends Node

var jugador_actual:Jugador = null setget set_jugador_actual, get_jugador_actual

func set_jugador_actual(jugador: Jugador) -> void:
	jugador_actual = jugador

func get_jugador_actual() -> Jugador:
	return jugador_actual

func _ready():
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func _on_nave_destruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Jugador:
		jugador_actual = null
	
