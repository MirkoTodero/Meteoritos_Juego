extends EnemigoBase

class_name EnemigoOrbital

export var max_rango_ataque:float = 1400.0

var base_duenia:Node2D

func _ready() -> void:
	Eventos.connect("base_destruida", self, "_on_base_destruida")
	canion.set_esta_disparando(true)

func crear(pos:Vector2, duenia:Node2D) -> void:
	global_position = pos
	base_duenia = duenia

func rotar_hacia_jugador() -> void:
	.rotar_hacia_jugador()
	if dir_jugador.length() > max_rango_ataque:
		canion.set_esta_disparando(false)
	else:
		canion.set_esta_disparando(true)

func _on_base_destruida(base:Node2D, pos) -> void:
	if base == base_duenia:
		destruir()
