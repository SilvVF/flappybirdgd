class_name Game
extends Node

@onready var bird: Bird = $Bird
@onready var bird_start := $BirdStart as Marker2D
@onready var top: Area2D = $Top
@onready var bottom: Area2D = $Bottom
@onready var timer: Timer = $Timer
@onready var score_label: Label = $Score
@onready var pipe_spawner: PackedScene = load("res://pipe_spawner.tscn")
@onready var menu: Menu = $Menu

var score: int = 0

func _ready() -> void:	
	bird.disable()
	menu.visible = true
	menu.on_start.connect(start_game)

func start_game():
	menu.visible = false
	score_label.text = str(0)
	
	bird.position = bird_start.position
	
	top.body_entered.connect(on_entered)
	bottom.body_entered.connect(on_entered)
	timer.timeout.connect(on_timeout)
	
	bird.enable()
	timer.start()
	

func on_entered(body: Node2D) -> void:
	if body is Bird:
		end_game()
	

func on_pipe_exit():
	score += 1
	score_label.text = str(score)
	
	timer.wait_time -= roundi(score / 10.0)

func on_timeout() -> void:
	var spawner := pipe_spawner.instantiate() as PipeSpawner	
	spawner.connect("pipe_touched", on_entered)
	spawner.connect("pipe_exiting", on_pipe_exit)
	add_child(spawner)
	move_child(spawner, 0)
	
func end_game() -> void:
	get_tree().call_group("pipe_spawner", "queue_free")
	get_tree().change_scene_to_file("res://game.tscn")

