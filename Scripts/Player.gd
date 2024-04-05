extends CharacterBody2D

const SPEED = 600.0
var screen_size

signal hit
signal shoot

func _ready():
	screen_size = get_viewport_rect().size

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
	
	if Input.is_action_pressed("ship_shoot"):
		shoot.emit()
	
	position.x += SPEED * direction * delta
	
	position = position.clamp(minBuffer, maxBuffer)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	

func _on_area_2d_body_entered(body):
	if body.get_groups().find("Enemies") != -1 and $HitTimer.get_time_left() == 0:
		hit.emit()
		$HitTimer.start()
	if body.get_groups().find("enemy_projectiles") != -1 and $HitTimer.get_time_left() == 0:
		hit.emit()
		$HitTimer.start()
