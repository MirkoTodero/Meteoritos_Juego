extends Node

export(String, FILE, "*.tscn") var nivel_inicial = ""

func _ready() -> void:
	OS.set_window_fullscreen(true)
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)

func _on_Button_pressed() -> void:
	MusicaJuego.play_boton()
	get_tree().change_scene(nivel_inicial)

func _on_Button2_pressed():
	get_tree().quit()
