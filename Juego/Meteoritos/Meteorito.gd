extends RigidBody2D

class_name Meteorito

export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base:float = 10.0

onready var animacion_impacto:AnimationPlayer = $AnimationPlayer

var hitpoints:float

func _ready()-> void:
	angular_velocity = vel_ang_base

func aleatorizar_velocidad() -> float:
	randomize()
	return rand_range(1.1, 1.4)

func crear(pos: Vector2, dir: Vector2, tamanio:float) -> void:
	#Calcular Tamanio, Masa y Colisionador
	position = pos
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#Velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * aleatorizar_velocidad()
	angular_velocity = (vel_ang_base / tamanio) * aleatorizar_velocidad()
	#Vida segun tamanio
	hitpoints = hitpoints_base * tamanio
	print("hitpoints", hitpoints)

func recibir_danio(danio:float) -> void:
	$AnimationPlayer.play("impacto")
	hitpoints -= danio
	if hitpoints <= 0:
		destruir()

func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()
