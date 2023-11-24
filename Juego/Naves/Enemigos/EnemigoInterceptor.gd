extends EnemigoBase

class_name EnemigoInterceptor

enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

var estado_ia_actual:int = ESTADO_IA.ATACANDOP
var potencia_actual:float = 0.0

export var potencia_max:float = 750.0

func _ready()->void:
	Eventos.emit_signal("minimapa_objeto_creado")

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_jugador.normalized() * potencia_actual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, - potencia_max, potencia_max)
	linear_velocity.y = clamp(linear_velocity.y, - potencia_max, potencia_max)

func controlador_estados_ia(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canion.set_esta_disparando(false)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOQ:
			canion.set_esta_disparando(true)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOP:
			canion.set_esta_disparando(true)
			potencia_actual = potencia_max
		ESTADO_IA.PERSECUCION:
			canion.set_esta_disparando(false)
			potencia_actual = potencia_max
		_:
			printerr("Error de estado")
	
	estado_actual = nuevo_estado

func _on_AreaDisparo_body_entered(_body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.ATACANDOP)

func _on_AreaDisparo_body_exited(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.PERSECUCION)

func _on_AreaDeteccion_body_entered(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.ATACANDOQ)

func _on_AreaDeteccion_body_exited(body: Node) -> void:
	controlador_estados_ia(ESTADO_IA.ATACANDOP)
