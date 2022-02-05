extends Node2D

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

var maus_sichtbar:bool=true
var old_maus_pos:Vector2
var mittelpunkt:Vector2
var hscroll_bereich_halbe:float
var vscroll_bereich_halbe:float
var hscroll_multi:float
var vscroll_multi:float

func _ready():
	print(get_viewport_rect().size)
	z_windrichtung = get_node("Camera2D/HUD/Sp_Windrichtung")
	z_hscrollbar = get_node("Camera2D/HUD/HScrollBar")
	z_vscrollbar = get_node("Camera2D/HUD/VScrollBar")
	z_Kamera = get_node("Camera2D")
	z_hud = get_node("Camera2D/HUD")
	bootBody = get_node("Boot/KinematicBody2D")
	hscroll_bereich_halbe = ((z_hscrollbar.max_value - z_hscrollbar.min_value) / 2)
	vscroll_bereich_halbe = ((z_vscrollbar.max_value - z_vscrollbar.min_value) / 2)

func _process(delta):
	z_Kamera.global_position = bootBody.global_position

func set_windrichtung():
	if windrichtung > PI:
		windrichtung = windrichtung - PI*2
	elif windrichtung < -PI:
		windrichtung = windrichtung + PI*2
	z_windrichtung.global_rotation = windrichtung
	Global.windrichtung = windrichtung

func steuerung_aktiv():
	if maus_sichtbar:
		maus_sichtbar = false
		# ermittel die aktuelle Mauspos
		old_maus_pos = get_viewport().get_mouse_position()
		# ermittel Fenstergröße und teile sie durch 2
		mittelpunkt = get_viewport_rect().size / 2
		# setze Mauszeiger in die mitte des Fensters
		################## mauszeiger auf werte der beiden Potis setzen
		var dummi:Vector2
		vscroll_multi = (get_viewport_rect().size.y) / (z_vscrollbar.max_value - z_vscrollbar.min_value + 1)
		dummi.y = ((z_vscrollbar.value - z_vscrollbar.min_value + 1) * vscroll_multi) - mittelpunkt.y
		hscroll_multi = get_viewport_rect().size.x / (z_hscrollbar.max_value - z_hscrollbar.min_value)
		dummi.x = (z_hscrollbar.value - z_hscrollbar.min_value) * hscroll_multi
		get_viewport().warp_mouse(dummi)
		# Mauszeiger unsichtbar machen
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func steuerung_deaktiv():
	maus_sichtbar = true
	get_viewport().warp_mouse(Vector2(old_maus_pos))
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("test_wind_plus",true):
		windrichtung = z_windrichtung.rotation + EinGrad
		set_windrichtung()
	if event.is_action_pressed("test_wind_minus",true):
		windrichtung = z_windrichtung.rotation - EinGrad
		set_windrichtung()
	if event.is_action_pressed("links",true):
		z_hscrollbar.value -= 0.05
	if event.is_action_pressed("oben"):
		pass
		#print("Aktion oben")
	if event.is_action_pressed("rechts",true):
		z_hscrollbar.value += 0.05
	if event.is_action_pressed("unten"):
		pass
		#print("Aktion unten")
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
	if event is InputEventMouseButton:
		if event.button_index ==  BUTTON_RIGHT:
			# dies event wird zweimal aufgerufen,
			# einmal beim drücken, hierbei ist pressed = true
			# und ein zweitesmal beim loslassen, hierbei ist pressed = false
			if event.pressed:
				steuerung_aktiv()
			else:
				steuerung_deaktiv()
	if event is InputEventMouseMotion and maus_sichtbar == false:
		var dummi = ((event.position - mittelpunkt) / mittelpunkt)
		z_hscrollbar.value = dummi.x * hscroll_bereich_halbe
		z_vscrollbar.value = (dummi.y + mittelpunkt.y) * vscroll_bereich_halbe
	print(event.position)
	print(get_viewport().get_mouse_position())
	print("-")

func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			if maus_sichtbar == false:
				steuerung_deaktiv()
			print("Maus im Fenster")
		NOTIFICATION_WM_MOUSE_ENTER:

			print("Maus ausserhalb des Fensters")
