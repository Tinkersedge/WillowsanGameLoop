extends Node2D


func _ready() -> void:
	#ChatDataMgr.ready()
	#TranslationServer.set_locale("ko")
	# Puts Kevin in front of whatever door he came out of
	if TransportMgr.insideLocation != Vector2.ZERO:
		$Kevin.position = TransportMgr.insideLocation
		TransportMgr.insideLocation = Vector2.ZERO
