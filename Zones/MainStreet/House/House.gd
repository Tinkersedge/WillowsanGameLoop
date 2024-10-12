extends Node2D


func _ready() -> void:
	Signals.emit_signal("checkLocation", "enterHouse")
