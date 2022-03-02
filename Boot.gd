extends KinematicBody2D

var z_ruder:Node
var z_mast:Node
var z_boot_PhysicBody:Node
var lokal_windrichtung:float=0
var differenz:float = 0
var seil:float = 1
var segel:float = 1
var kraft_auf_segel:float = 0
var geschw:float = 0
var segel_drehung_uhrz:bool = false
var div:float = 0
var schaden:float = 0
var drehung:float = 0

func _ready():
	Global.connect("neu_seil", self, "fn_neu_seil")
	Global.connect("neu_segel", self, "fn_neu_segel")
	Global.connect("neu_ruder", self, "fn_neu_ruder")
	z_ruder = get_node("Sp_Ruder")
	z_mast = get_node("Sp_Mast")
	
func fn_neu_ruder(wert):
	z_ruder.rotation = wert

func fn_neu_seil(wert):
	seil = wert / 10

func fn_neu_segel(wert):
	segel = wert

func _physics_process(delta):
	if rotation > PI:					# bogenmaß im Bereich 2*PI halten
		rotation = rotation - PI*2
	elif rotation < -PI:
		rotation = rotation + PI*2
	if rotation < Global.windrichtung:						# Wind von der linken Seite
		lokal_windrichtung = rotation + (2 * PI)
	else:
		lokal_windrichtung = rotation						# Wind von der rechten Seite
	differenz = lokal_windrichtung - Global.windrichtung - PI
	if abs(differenz) < seil:								# Wind von vorne Segel gleich Wind
		z_mast.rotate((differenz *-1) - z_mast.rotation)
		# Wenn keine Kraft in Fahrtrichtung

	elif differenz > seil and differenz < (PI-seil):		# Wind links und Segel im Wind
		z_mast.rotation = seil *-1
		segel_drehung_uhrz = false
	elif differenz < seil and differenz > (PI-seil)*-1:		# Wind rechts und Segel im Wind
		z_mast.rotation = seil
		segel_drehung_uhrz = true
	else:													# Wind von hinten
		if segel_drehung_uhrz:
			z_mast.rotation = seil
			segel_drehung_uhrz = true
		else:
			z_mast.rotation = seil *-1
			segel_drehung_uhrz = false
	# Kraft auf Segel 0 - 10
	# Windrichtung im 90° zur Segelfläche = 100%
	Global.kraft_auf_segel = abs(sin(rotation + z_mast.rotation - Global.windrichtung)) * Global.windstaerke * segel
	# Kraft auf Segel im 90° zur Fahrtrichtung = 100%
	# um ständig etwas vortrieb zu haben addiere ich die hälfte von Segel hinzu
	Global.kraft_in_fahrtrichtung = Global.kraft_auf_segel * abs(sin(z_mast.rotation)) + (segel/2)
	Global.kraft_in_fahrtrichtung += (Global.kraft_auf_segel - Global.kraft_in_fahrtrichtung) / 10
	#Global.kraft_in_fahrtrichtung *= segel
	# Zeitlicher An/Abstieg der Geschwindigkeit
	if Global.kraft_in_fahrtrichtung > Global.geschwindigkeit:
		div = Global.kraft_in_fahrtrichtung - Global.geschwindigkeit
		Global.geschwindigkeit += div / 200
	if Global.kraft_in_fahrtrichtung < Global.geschwindigkeit:
		div = Global.geschwindigkeit - Global.kraft_in_fahrtrichtung
		Global.geschwindigkeit -= div / 500
	# 
#	if Global.geschwindigkeit < 0.5:
#		$Icon.visible = true
#		drehung = z_ruder.rotation / -800
#	else:
#		$Icon.visible = false
	if Global.in_fahrt:
		drehung = z_ruder.rotation * -Global.geschwindigkeit / 1000
		rotate(drehung)
		var velocity = Vector2(Global.geschwindigkeit * 20,0)
		velocity = velocity.rotated(rotation)
		velocity = move_and_slide(velocity)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if Global.geschwindigkeit > 2:
				schaden += Global.geschwindigkeit
				print(schaden)
				#Global.geschwindigkeit = 0
