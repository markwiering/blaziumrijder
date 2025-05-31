extends Node3D

@export var Volg_Kamera: Camera3D
@export var Vaste_Kamera: Camera3D
@export var Kamera_Achteruit: Camera3D
var vasteKamera = false;

var actieve_kamera: Camera3D

func _ready():
	if(AllesOverkoepelendeKnoop.muziekAan):
		$Muziek.play();
	actieve_kamera = Volg_Kamera;
	Volg_Kamera.make_current();

func ZetJuisteKamera():
	if vasteKamera:
		Vaste_Kamera.make_current()
		actieve_kamera = Vaste_Kamera;
	else:
		Volg_Kamera.make_current();
		actieve_kamera = Volg_Kamera;

func _input(event):
	if event.is_action_pressed("c"):
		vasteKamera = !vasteKamera;
		ZetJuisteKamera();
	if event.is_action_pressed("l"):
		if actieve_kamera == Kamera_Achteruit:
			ZetJuisteKamera();
		else:
			Kamera_Achteruit.make_current();
			actieve_kamera = Kamera_Achteruit;
	elif event.is_action_pressed("m") and AllesOverkoepelendeKnoop.muziekAan:
		$Muziek.stop();
	elif event.is_action_pressed("m") and not AllesOverkoepelendeKnoop.muziekAan:
		$Muziek.play();
	elif event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://hoofdmenu.tscn")


func _sensor_betreden(lichaam: Node3D) -> void:
	if(lichaam is VehicleBody3D):
		$GameInProgress.visible = true;


func _indien_muziek_klaar() -> void:
	$Muziek.play();
