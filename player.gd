class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)

@export var speed = 300
@export var rate_of_fire = 0.25

@onready var muzzle = $Muzzle

var laser_scene = preload("res://scenes/laser.tscn")

var shoot_cd := false

func _process(_delta: float) -> void:
	
	#if Input.is_action_pressed("speed+"):
		#rate_of_fire = rate_of_fire - 0.05
		#await get_tree().create_timer(1.5).timeout
		#if rate_of_fire <= 0:
			#rate_of_fire = 0.05

	#if Input.is_action_pressed("speed-"):
		#rate_of_fire = rate_of_fire + 0.05
		#await get_tree().create_timer(1.5).timeout
		#if rate_of_fire >= 2:
			#rate_of_fire = 2
	
	
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(_delta: float) -> void:
	var direction = Vector2(Input.get_axis("move_left",
	 "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = direction * speed
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, 
	get_viewport_rect().size)

func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)

func die():
	queue_free()
	
