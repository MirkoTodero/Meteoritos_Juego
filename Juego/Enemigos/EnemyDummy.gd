extends Node2D

var hitpoints:float = 15.0

func _process(_delta: float) -> void:
	$Canion.set_esta_disparando(true)

func _on_Area2D_body_entered(body) -> void:
	if body is Jugador:
		body.destruir()

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		queue_free()
