extends Node2D


var richtung:Vector2 = Vector2(0,0)
var zoom:int = 1
var z_kamera:Camera2D

func _ready():
	z_kamera = get_node("../Camera2D")
	pass # Replace with function body.


#func _process(delta):
#	pass

func _input(event):
	if event is InputEventKey:
		
		if event.is_action("links"):
			richtung.x = -1
		if event.is_action("oben"):
			richtung.y = -1
		if event.is_action("rechts"):
			richtung.x = 1
		if event.is_action("unten"):
			richtung.y = 1
	if event is InputEventMouse:
		if event.button_mask == 8:
			zoom += 1
			zoom = clamp(zoom, 1, 15)
			z_kamera.set_zoom(Vector2(zoom,zoom))
			#z_hud.set_scale(Vector2(zoom,zoom))
		if event.button_mask == 16:
			zoom -= 1
			zoom = clamp(zoom, 1, 15)
			z_kamera.set_zoom(Vector2(zoom,zoom))
			#z_hud.set_scale(Vector2(zoom,zoom))

func _physics_process(delta):
	$KinematicBody2D.move_and_slide(richtung * 90)
	richtung = Vector2.ZERO

