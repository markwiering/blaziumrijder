extends Control

func _ready():
	if(AllesOverkoepelendeKnoop.muziekAan):
		$Muziek.play();
		
func _input(event):
	if event.is_action_pressed("m") and AllesOverkoepelendeKnoop.muziekAan:
		$Muziek.stop();
	elif event.is_action_pressed("m") and not AllesOverkoepelendeKnoop.muziekAan:
		$Muziek.play();

func _indien_starten_ingedrukt() -> void:
	get_tree().change_scene_to_file("res://Speelwereld.tscn");
	

func _indien_volledig_scherm_ingedrukt() -> void:
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)


func _indien_afsluitknop_ingedrukt() -> void:
	get_tree().quit();


func _indien_muziek_klaar() -> void:
	$Muziek.play();
