extends KinematicBody2D

var z_ruder:Node
var z_mast:Node
var z_boot_PhysicBody:Node
var z_prozessbar
var rotgew:float = 2
var lokal_windrichtung:float=0
var differenz:float = 0
var seil:float = 1
var kraft_auf_segel:float = 0
var geschw:float = 0
var segel_drehung_uhrz:bool = false
var fahrt_richtung:float = 0

func _ready():
	Global.connect("neu_segel", self, "fn_neu_segel")
	Global.connect("neu_ruder", self, "fn_neu_ruder")
	z_ruder = get_node("Sp_Ruder")
	z_mast = get_node("Sp_Segel")
	
func fn_neu_ruder(wert):
	z_ruder.rotation = wert

func fn_neu_segel(wert):
	seil = wert / 10

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
	Global.kraft_auf_segel = abs(sin(rotation + z_mast.rotation - Global.windrichtung)) * Global.windstaerke * abs(z_mast.rotation)
	var div:float = 0 
	if Global.kraft_auf_segel > geschw:
		div = Global.kraft_auf_segel - geschw
		geschw += div / 100
	if Global.kraft_auf_segel < geschw:
		div = geschw - Global.kraft_auf_segel
		geschw -= div / 400
	var drehung:float = z_ruder.rotation * -geschw / 1000
	var velocity = Vector2(geschw * 5,0)
	velocity = velocity.rotated(rotation)
	move_and_slide(velocity)
	rotate(drehung)
