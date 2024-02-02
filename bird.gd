class_name Bird
extends CharacterBody2D

@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.35
@export var jump_time_to_descent : float = 0.25

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var enabled: bool = false

func _physics_process(delta: float) -> void:
	if !enabled:
		return
	
	velocity.y += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	move_and_slide()
	

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump() -> void:
	velocity.y = jump_velocity

func enable() -> void:
	enabled = true
	
func disable() -> void:
	enabled = false
