extends Node2D

const EinGrad:float = PI/180

var z_windrichtung:Sprite
var z_sb_ruder:HScrollBar
var z_sb_seil:VScrollBar
var z_sb_segel:VScrollBar
var z_Kamera:Camera2D
var z_hud:Control
var z_cam: Camera2D

var zoom:int = 1
var windrichtung:float
var maus_sichtbar:bool=true
var old_maus_pos:Vector2
var proz_fenster:Vector2
var proz_seil:float
var proz_ruder:float
var proz_segel:float
var aktiv_id:int = 0
var im_hafen:bool = false

func _ready():
	z_windrichtung = get_node("Camera2D/HUD/Sp_Windrichtung")
	z_sb_ruder = get_node("Camera2D/HUD/HSBRuder")
	z_sb_seil = get_node("Camera2D/HUD/VSBSeil")
	z_sb_segel = get_node("Camera2D/HUD/VSBSegel")
	z_Kamera = get_node("Camera2D")
	z_hud = get_node("Camera2D/HUD")
	Global.z_boot = get_node("Boot/KinematicBody2D")
	proz_seil = (z_sb_seil.max_value - z_sb_seil.min_value) / 100
	proz_ruder = (z_sb_ruder.max_value - z_sb_ruder.min_value) / 100
	proz_segel = (z_sb_segel.max_value - z_sb_segel.min_value) / 100
	
func _process(delta):
	z_Kamera.global_position = Global.z_boot.global_position

func set_windrichtung():
	if windrichtung > PI:
		windrichtung = windrichtung - PI*2
	elif windrichtung < -PI:
		windrichtung = windrichtung + PI*2
	z_windrichtung.global_rotation = windrichtung
	Global.windrichtung = windrichtung

func steuerung_aktiv(id:int):
	if aktiv_id == 0:
		var dummi = Vector2.ZERO
		aktiv_id = id
		maus_sichtbar = false
		# ermittel die aktuelle Mauspos
		old_maus_pos = get_viewport().get_mouse_position()
		################## mauszeiger auf werte der beiden Potis setzen
		proz_fenster = get_viewport_rect().size / 100
		if id == 1:
			dummi.x = (z_sb_ruder.value / proz_ruder + 50) * proz_fenster.x
			dummi.y = (z_sb_seil.value - z_sb_seil.min_value) / proz_seil * proz_fenster.y
		if id == 2:
			dummi.x = get_viewport_rect().size.x / 2
			dummi.y = (z_sb_segel.value - z_sb_segel.min_value) / proz_segel * proz_fenster.y
		get_viewport().warp_mouse(dummi)
		# Mauszeiger unsichtbar machen
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func steuerung_deaktiv(id:int):
	if aktiv_id == id:
		aktiv_id = 0
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
		z_sb_seil.value -= 1
	if event.is_action("rechts"):
		z_sb_ruder.value += 0.05
	if event.is_action_pressed("unten"):
		z_sb_seil.value += 1
	if event.is_action_pressed("steuerung_a"):
		steuerung_aktiv(1)
	if event.is_action_released("steuerung_a"):
		steuerung_deaktiv(1)
	if event.is_action_pressed("steuerung_b"):
		steuerung_aktiv(2)
	if event.is_action_released("steuerung_b"):
		steuerung_deaktiv(2)
	if event is InputEventMouse:
		if event.button_mask == 8:
			zoom += 1
			zoom = clamp(zoom, 1, 15)
			z_Kamera.set_zoom(Vector2(zoom,zoom))
			z_hud.set_scale(Vector2(zoom,zoom))
		if event.button_mask == 16:
			zoom -= 1
			zoom = clamp(zoom, 1, 15)
			z_Kamera.set_zoom(Vector2(zoom,zoom))
			z_hud.set_scale(Vector2(zoom,zoom))
	if event is InputEventMouseMotion and maus_sichtbar == false:
		var x = clamp(get_viewport().get_mouse_position().x, 0, get_viewport_rect().size.x)
		var y = clamp(get_viewport().get_mouse_position().y, 0, get_viewport_rect().size.y)
		proz_fenster = get_viewport_rect().size / 100 # größe vom fenster kann sich ändern
		if aktiv_id == 1:
			z_sb_seil.value = z_sb_seil.min_value + (y / proz_fenster.y) * proz_seil
			z_sb_ruder.value = z_sb_ruder.min_value + (x / proz_fenster.x) * proz_ruder
		if aktiv_id == 2:
			z_sb_segel.value = z_sb_segel.min_value + (y / proz_fenster.y) * proz_segel

