extends Node

signal neu_ruder(wert)
signal neu_segel(wert)
signal neu_seil(wert)

var windrichtung:float = 0
var windstaerke:int = 10
var kraft_auf_segel:float = 0
var kraft_in_fahrtrichtung:float = 0
var geschwindigkeit:float = 0
var z_boot:Node2D
var in_fahrt:bool=true
var auf_insel:int = 0

var seekarte:String = "res://Seekarte.tscn"
var landkarte:String = "res://Landkarte.tscn"

func wechsel_szene():
	if auf_insel == 0:
		get_tree().change_scene(seekarte)
	else:
		get_tree().change_scene(landkarte)
		var datei = "res://welt/Land" + str(auf_insel) + ".tscn"
		var dummi = load(datei).instance()
		add_child(dummi)
		print(datei)
