extends NaveBase

class_name EnemigoBase

func _ready() -> void:
	canion.set_esta_disparando(true)

func _on_body_entered(body:Node) -> void:
	._on_body_entered(body)
	if body is Jugador:
		body.destruir()
		destruir()
