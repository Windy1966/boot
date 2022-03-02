extends Node2D

var boot_coll
var hafen_coll
var hafen_punkte
var hafen_schalter:bool=false
export var hafen_id:int

func _ready():
	hafen_coll = get_node("Anlegebereich/CollisionPolygon2D")
	hafen_punkte = hafen_coll.global_transform.xform(hafen_coll.polygon)

func _physics_process(delta):
	if hafen_schalter:
		_insgesamt_im_hafen()

func _on_Anlegebereich_body_entered(body):
	hafen_schalter = true

func _on_Anlegebereich_body_exited(body):
	hafen_schalter = false

func _insgesamt_im_hafen():
	boot_coll = Global.z_boot.get_node("CollisionPolygon2D")
	var boot_punkte = boot_coll.global_transform.xform(boot_coll.polygon)
	var boot_im_feld := true
	for point in boot_punkte:
		if not Geometry.is_point_in_polygon(point, hafen_punkte):
			boot_im_feld = false
			break
	if hafen_schalter and boot_im_feld and Global.geschwindigkeit < 0.8:
		Global.in_fahrt = false
		#Global.geschwindigkeit = 0
		anlegen()
	if Input.is_key_pressed(KEY_Y):
		Global.in_fahrt = true
		print("Abgelegt")

func anlegen():
	Global.auf_insel = hafen_id
	Global.wechsel_szene()
