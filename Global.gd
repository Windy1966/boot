extends Node

signal neu_ruder(wert)
signal neu_segel(wert)
signal neu_seil(wert)

var windrichtung:float = 0
var windstaerke:int = 10
var kraft_auf_segel:float = 0
var kraft_in_fahrtrichtung:float = 0
var geschwindigkeit:float = 0
