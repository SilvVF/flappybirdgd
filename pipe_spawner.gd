class_name PipeSpawner
extends Node2D

signal pipe_touched(body: Node2D)
signal pipe_exiting

@export var speed: float = 400
@export var max_height_frac: float = 0.7
@export var min_height_frac: float = 0.2
@export var gap: float = 150.0

@onready var top: Area2D = $Top
@onready var bottom: Area2D = $Bottom
@onready var top_sprite: Sprite2D = $Top/Sprite2D
@onready var bottom_sprite: Sprite2D = $Bottom/Sprite2D

@onready var screen_size: Vector2 = get_viewport_rect().size

@onready var top_collider: CollisionShape2D = $Top/CollisionShape2D
@onready var bottom_collider: CollisionShape2D = $Bottom/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top.body_entered.connect(on_entered)
	bottom.body_entered.connect(on_entered)
	spawn()

func on_entered(body: Node2D):
	pipe_touched.emit(body)

func _physics_process(delta: float) -> void:
	top.position = top.position.lerp(top.position + Vector2.LEFT, speed * delta)
	bottom.position = bottom.position.lerp(bottom.position + Vector2.LEFT, speed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if top.position.x < 0 or bottom.position.x < 0:
		pipe_exiting.emit()
		queue_free()

func spawn():
	var diff = randi_range(
			roundi(top_sprite.scale.y * min_height_frac),
			roundi(top_sprite.scale.y * max_height_frac))
	# scale sprites based on random both sprites assumed same size
	top_sprite.scale.y += diff
	bottom_sprite.scale.y -= diff
	# recreate collision shapes based on new scaling
	var top_shape: RectangleShape2D = RectangleShape2D.new()
	var bottom_shape: RectangleShape2D = RectangleShape2D.new()
	
	var width := top_sprite.texture.get_width() * top_sprite.scale.x

	var th: float = top_sprite.texture.get_height() * top_sprite.scale.y
	var bh: float = bottom_sprite.texture.get_height() * bottom_sprite.scale.y
	
	top_shape.size = Vector2(width, th)
	bottom_shape.size = Vector2(width, bh)
	
	top_collider.shape = top_shape
	bottom_collider.shape = bottom_shape
	# postion at top and bottom edges of far right
	top.position = Vector2(screen_size.x, 0)
	bottom.position = Vector2(screen_size.x, th + bh / 2.0 + gap)

	
	
	
