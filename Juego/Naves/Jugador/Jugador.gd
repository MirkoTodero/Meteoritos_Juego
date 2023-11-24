extends NaveBase

class_name Jugador

export var potencia_motor:int = 18
export var potencia_rotacion:int = 260
export var estela_maxima:int = 150

var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

onready var laser:RayoLaser = $LaserBeam2D setget ,get_laser
onready var estela:Estela = $InicioEstelaJugador/Trail2D
onready var motor_sfx:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget ,get_escudo

func _ready():
	DatosJuego.set_jugador_actual(self)

func get_laser() -> RayoLaser:
	return laser

func get_escudo() ->Escudo:
	return escudo

func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activado():
		return
	if event.is_action_pressed("disparo_laser"):
		laser.set_is_casting(true)
	if event.is_action_released("disparo_laser"):
		laser.set_is_casting(false)
	
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		
	if (event.is_action_released("mover_adelante") or event.is_action_released("mover_atras")):
		motor_sfx.sonido_off()
	
	if event.is_action_pressed("activar_escudo") and not escudo.get_esta_activado():
		escudo.activar()

func _process(_delta: float) -> void:
	player_input()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func player_input() -> void:
	if not esta_input_activado():
		return
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
		motor_sfx.sonido_on()
	if Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
		motor_sfx.sonido_on()
	
	dir_rotacion = 0
	if Input.is_action_pressed("rotar_antihorario"):
		dir_rotacion -= 1
	if Input.is_action_pressed("rotar_horario"):
		dir_rotacion += 1
	
	if Input.is_action_pressed("disparo_principal"):
		canion.set_esta_disparando(true)
	
	if Input.is_action_just_released("disparo_principal"):
		canion.set_esta_disparando(false)

func esta_input_activado() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
	
	return true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		controlador_estados(ESTADO.VIVO)

func desactivar_controles() -> void:
	controlador_estados(ESTADO.SPAWN)
	empuje = Vector2.ZERO
	motor_sfx.sonido_off()
	laser.set_is_casting(false)
