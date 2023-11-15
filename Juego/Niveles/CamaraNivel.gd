extends Camera2D

onready var tween_zoom:Tween = $TweenZoom

var zoom_original:Vector2
var puede_hacer_zoom:bool = true setget set_puede_hacer_zoom

func _ready() -> void:
	zoom_original = zoom

func set_puede_hacer_zoom(puede: bool) -> void:
	puede_hacer_zoom = puede

func zoom_suavizado(nuevo_zoom_x:float, nuevo_zoom_y:float, timepo_transicion:float) -> void:
	tween_zoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevo_zoom_x, nuevo_zoom_y),
		timepo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_zoom.start()

func devolver_zoom_original() -> void:
	puede_hacer_zoom = false
	zoom_suavizado(zoom_original.x, zoom_original.y, 1.0)
