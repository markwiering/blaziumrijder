extends Node

var muziekAan = true;

func _input(event):
	if event.is_action_pressed("m"):
		muziekAan = !muziekAan;
