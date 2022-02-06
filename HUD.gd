extends Control

func _process(delta):
	$PBarKraftAufSegel.value = Global.kraft_auf_segel
	$PBarKraftInFahrtrichtung.value = Global.kraft_in_fahrtrichtung
	$PBarGeschwindigkeit.value = Global.geschwindigkeit

func _on_HSBRuder_value_changed(value):
	Global.emit_signal("neu_ruder", value * -1)

func _on_VSBSeil_value_changed(value):
	Global.emit_signal("neu_seil", 11 - value)
	pass # Replace with function body.

func _on_VSBSegel_value_changed(value):
	Global.emit_signal("neu_segel", value)
	pass # Replace with function body.
