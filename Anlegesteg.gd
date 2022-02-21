extends Node2D

var boot_coll
var hafen_coll
var hafen_punkte
var hafen_schalter:bool=false

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
	if boot_im_feld:
		print("Im Hafenbereich")
