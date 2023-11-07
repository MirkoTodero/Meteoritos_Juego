extends Area2D

class_name Escudo

var esta_activado:bool = false setget ,get_esta_activado

export var energia:float = 8.0
export var radio_desgaste:float = -1.6

func _process(delta: float) -> void:
	energia += radio_desgaste * delta
	
	if energia <= 0.0:
		desactivar()

func get_esta_activado() -> bool:
	return esta_activado

func _ready() -> void:
	set_process(false)
	controlador_colisionador(true)

func controlador_colisionador(esta_desactivado: bool)-> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)

func activar() -> void:
	if energia <= 0.0:
		return
	
	esta_activado = true
	controlador_colisionador(false)
	$AnimationPlayer.play("activandose")

func _on_AnimationPlayer_animation_finished(anim_name: String)-> void:
	if anim_name == "activandose" and esta_activado:
		$AnimationPlayer.play("activado")
		set_process(true)

func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlador_colisionador(true)
	$AnimationPlayer.play_backwards("activandose")

func _on_body_entered(body: Node) -> void:
	body.queue_free()