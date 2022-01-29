extends Node2D

var global:Node
const EinGrad:float = PI/180

var z_windrichtung:Sprite
var windrichtung:float
var z_hscrollbar:HScrollBar
var z_vscrollbar:VScrollBar
var z_Kamera:Camera2D
var z_hud:Control

var bootBody: KinematicBody2D
var cam: Camera2D
var zoom:int = 1

func _ready():
	z_windrichtung = get_node("Camera2D/HUD/Sp_Windrichtung")
	z_hscrollbar = get_node("Camera2D/HUD/HScrollBar")
	z_vscrollbar = get_node("Camera2D/HUD/VScrollBar")
	z_Kamera = get_node("Camera2D")
	z_hud = get_node("Camera2D/HUD")
	
	bootBody = get_node("Boot/KinematicBody2D")


func _process(delta):
	z_Kamera.global_position = bootBody.global_position
	pass

func set_windrichtung():
	if windrichtung > PI:
		windrichtung = windrichtung - PI*2
	elif windrichtung < -PI:
		windrichtung = windrichtung + PI*2
	z_windrichtung.global_rotation = windrichtung
	Global.windrichtung = windrichtung

func _input(event):
	if event.is_action_pressed("test_wind_plus",true):
		windrichtung = z_windrichtung.rotation + EinGrad
		set_windrichtung()
	if event.is_action_pressed("test_wind_minus",true):
		windrichtung = z_windrichtung.rotation - EinGrad
		set_windrichtung()
	if event.is_action_pressed("links",true):
		z_hscrollbar.value -= 0.05
		print("Aktion links")
	if event.is_action_pressed("oben"):
		print("Aktion oben")
	if event.is_action_pressed("rechts",true):
		z_hscrollbar.value += 0.05
		print("Aktion rechts")
	if event.is_action_pressed("unten"):
		print("Aktion unten")
	if event is InputEventMouse:
		if event.button_mask == 8:
			zoom += 1
			zoom = clamp(zoom, 2, 15)
			z_Kamera.set_zoom(Vector2(zoom,zoom))
			z_hud.set_scale(Vector2(zoom,zoom))
		if event.button_mask == 16:
			zoom -= 1
			zoom = clamp(zoom, 2, 15)
			z_Kamera.set_zoom(Vector2(zoom,zoom))
			z_hud.set_scale(Vector2(zoom,zoom))
		print(zoom)
