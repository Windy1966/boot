extends Node2D

var vorbelegung = {
	"links" : KEY_A,
	"oben" : KEY_W,
	"rechts" : KEY_D,
	"unten" : KEY_S,
	"steuerung_a" : KEY_Q,
	"steuerung_b" : KEY_E,
	"test_wind_plus" : KEY_P,
	"test_wind_minus" : KEY_O
	}

var seekarte

func _ready():
	initKeymap(vorbelegung)
	#OS.window_fullscreen = true

func initKeymap(keymap:Dictionary):
	for action in keymap:
		# besteht die action bereits, lösche sie zunächst
		if InputMap.has_action(action):
			InputMap.erase_action(action)
		InputMap.add_action(action)
		var ev = InputEventKey.new()
		ev.scancode = keymap[action]    
		InputMap.action_add_event(action, ev) 


func _on_Button_pressed():
	Global.wechsel_szene()

