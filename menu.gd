class_name Menu
extends Control

signal on_start

@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(start_button_clicked)

func start_button_clicked() -> void:
	on_start.emit()
