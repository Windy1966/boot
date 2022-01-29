extends Control

func _on_HScrollBar_value_changed(value):
	Global.emit_signal("neu_ruder", value * -1)

func _on_VScrollBar_value_changed(value):
	Global.emit_signal("neu_segel", 11 - value)

func _process(delta):
	$ProgressBar.value = Global.kraft_auf_segel
