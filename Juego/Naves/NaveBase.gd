extends RigidBody2D

class_name NaveBase

enum ESTADO{VIVO, MUERTO, SPAWN, INVENCIBLE}

export var hitpoints:float = 20
export var num_explosiones:float = 0

var estado_actual:int = ESTADO.SPAWN

onready var canion:Canion = $Canion
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impacto_recibido:AudioStreamPlayer = $ImpactoDanio
onready var barra_salud:ProgressBar = $BarraSalud

func _ready():
	barra_salud.max_value = hitpoints
	barra_salud.value = hitpoints
	controlador_estados(estado_actual)

func controlador_estados(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida", self, global_position, num_explosiones)
			queue_free()
		_:
			printerr("Error de estado")
	estado_actual = nuevo_estado

func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
		
	barra_salud.controlar_barra(hitpoints, true)
	impacto_recibido.play()

func _on_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
