extends NinePatchRect

class_name ContenedorInformacion

var esta_activo:bool = true setget set_esta_activo

onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer
onready var animaciones:AnimationPlayer = $AnimationPlayer

export var auto_ocultar:bool = false setget set_auto_ocultar, get_auto_ocultar

func set_auto_ocultar(ocultar:bool) -> void:
	auto_ocultar = ocultar

func get_auto_ocultar():
	return auto_ocultar

func set_esta_activo(valor:bool) -> void:
	esta_activo = valor

func mostrar() -> void:
	if esta_activo:
		animaciones.play("mostrar")

func ocultar() -> void:
	if not esta_activo:
		animaciones.stop()
	animaciones.play("ocultar")

func ocultar_suavizado() -> void:
	if esta_activo:
		animaciones.play("ocultar_suavizado")

func mostrar_suavizado() -> void:
	if not esta_activo:
		return
	animaciones.play("mostrar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func modificar_texto(texto:String) -> void:
	texto_contenedor.text = texto

func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
