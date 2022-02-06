extends Node2D

const EinGrad:float = PI/180

var z_windrichtung:Sprite
var z_sb_ruder:HScrollBar
var z_sb_segel:VScrollBar
var z_Kamera:Camera2D
var z_hud:Control
var z_boot: KinematicBody2D
var z_cam: Camera2D

var zoom:int = 1
var windrichtung:float
var maus_sichtbar:bool=true
var old_maus_pos:Vector2
var proz_fenster:Vector2
var proz_segel:float
var proz_ruder:float

func _ready():
	z_windrichtung = get_node("Camera2D/HUD/Sp_Windrichtung")
	z_sb_ruder = get_node("Camera2D/HUD/HScrollBar")
	z_sb_segel = get_node("Camera2D/HUD/VScrollBar")
	z_Kamera = get_node("Camera2D")
	z_hud = get_node("Camera2D/HUD")
	z_boot = get_node("Boot/KinematicBody2D")
	proz_segel = (z_sb_segel.max_value - z_sb_segel.min_value) / 100
	proz_ruder = (z_sb_ruder.max_value - z_sb_ruder.min_value) / 100
	
func _process(delta):
	z_Kamera.global_position = z_boot.global_position

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
		################## mauszeiger auf werte der beiden Potis setzen
		var dummi:Vector2
		proz_fenster = get_viewport_rect().size / 100
		var x = (z_sb_ruder.value / proz_ruder + 50) * proz_fenster.x
		var y = (z_sb_segel.value - z_sb_segel.min_value) / proz_segel * proz_fenster.y
		get_viewport().warp_mouse(Vector2(x,y))
		# Mauszeiger unsichtbar machen
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func steuerung_deaktiv():
	maus_sichtbar = true
	get_viewport().warp_mouse(Vector2(old_maus_pos))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action("test_wind_plus"):
		windrichtung = z_windrichtung.rotation + EinGrad
		set_windrichtung()
	if event.is_action("test_wind_minus"):
		windrichtung = z_windrichtung.rotation - EinGrad
		set_windrichtung()
	if event.is_action("links"):
		z_sb_ruder.value -= 0.05
	if event.is_action_pressed("oben"):
		pass
		#print("Aktion oben")
	if event.is_action("rechts"):
		z_sb_ruder.value += 0.05
	if event.is_action_pressed("unten"):
		pass
		#print("Aktion unten")
	if event.is_action_pressed("steuerung"):
		steuerung_aktiv()
	if event.is_action_released("steuerung"):
		steuerung_deaktiv()
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
#	if event is InputEventMouseButton:
#		if event.button_index ==  BUTTON_RIGHT:
#			# dies event wird zweimal aufgerufen,
#			# einmal beim drücken, hierbei ist pressed = true
#			# und ein zweitesmal beim loslassen, hierbei ist pressed = false
#			if event.pressed:
#				steuerung_aktiv()
#			else:
#				steuerung_deaktiv()
	if event is InputEventMouseMotion and maus_sichtbar == false:
		var x = clamp(get_viewport().get_mouse_position().x, 0, get_viewport_rect().size.x)
		var y = clamp(get_viewport().get_mouse_position().y, 0, get_viewport_rect().size.y)
		proz_fenster = get_viewport_rect().size / 100 # größe vom fenster kann sich ändern
		z_sb_segel.value = z_sb_segel.min_value + (y / proz_fenster.y) * proz_segel
		z_sb_ruder.value = z_sb_ruder.min_value + (x / proz_fenster.x) * proz_ruder

#func _notification(what):
#	print(what)
#	match what:
#		NOTIFICATION_WM_MOUSE_EXIT:
#			print("Maus ausserhalb des Fensters")
#			#maus_sichtbar = true
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		NOTIFICATION_WM_MOUSE_ENTER:
#			if maus_sichtbar == false:
#				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#			print("Maus im Fenster")
			
