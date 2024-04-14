extends CharacterBody2D

const SPEED = 600.0
var screen_size
var shoot_enabled = true
var projectile = preload("res://Scenes/projectile_friendly.tscn")
var player_shoot_enabled = false

signal hit
signal shoot

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _physics_process(delta):
	var direction = 0
	var minBuffer = Vector2.ZERO
	var maxBuffer = Vector2.ZERO
	
	minBuffer.x = 35
	minBuffer.y = 35
	maxBuffer.x = screen_size.x - 35
	maxBuffer.y = screen_size.y - 35
	
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1
	
	if direction != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if Input.is_action_pressed("ship_shoot") && player_shoot_enabled:
		shoot.emit()
	
	position.x += SPEED * direction * delta
	
	position = position.clamp(minBuffer, maxBuffer)

func start(pos):
	position = pos
	show()
	shoot_enabled = true
	$CollisionShape2D.disabled = false
	set_player_shoot(true)

func disable_shoot():
	shoot_enabled = false
	
func get_shoot_enabled():
	return shoot_enabled

func _on_area_2d_body_entered(body):
	if body.get_groups().find("Enemies") != -1 and $HitTimer.get_time_left() == 0:
		hit.emit()
		$HitTimer.start()
	if body.get_groups().find("enemy_projectiles") != -1 and $HitTimer.get_time_left() == 0:
		hit.emit()
		$HitTimer.start()

func _on_player_shoot():
	if get_tree().get_nodes_in_group("friendly_projectiles").size() == 0 and shoot_enabled:
		$PlayerShot.play()
		var projectile_instance = projectile.instantiate()
	
		var projectile_spawn_location = Vector2.ZERO
	
		projectile_instance.spawn_position(position) 
		
		#print(projectile.name)
	
		get_tree().get_root().call_deferred("add_child", projectile_instance)
		
func set_player_shoot(value):
	player_shoot_enabled = value
