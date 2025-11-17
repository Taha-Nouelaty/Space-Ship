extends Node2D

@export var enemy_scences: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD

var player = null
var score := 0:
	set(value):
		score = value 
		hud.score = score

func _ready() -> void:
	score = 0
	player = get_tree().get_first_node_in_group("player") 
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)

func _on_enemy_spawn_timer_timeout() -> void:
	var e = enemy_scences.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50, 500), -50)
	e.killed.connect(_on_enemy_killed)
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	score += points
	print(score)
