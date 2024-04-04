extends CharacterBody2D

var speed = 100
var direction = 1
var screen_size

signal change_direction
signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var minBuffer = Vector2.ZERO
	var maxBuffer = Vector2.ZERO
	
	minBuffer.x = 35
	minBuffer.y = 35
	maxBuffer.x = screen_size.x - 35
	maxBuffer.y = screen_size.y - 35
	
	position.x += speed * direction * delta
	
	var unclamped_x_position = position.x
	
	position = position.clamp(minBuffer, maxBuffer)
	
	if position.x + (speed * direction * delta) >= maxBuffer.x or position.x + (speed * direction * delta) <= minBuffer.x:
		change_direction.emit()

func _on_change_direction():
	direction = -direction
	position.y += 20
	
func spawn_enemy(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func pause_movement():
	speed = 0
	
func increment_speed(total_enemy_count, enemy_count):
	speed += 10 + 2 * total_enemy_count / enemy_count
	print(speed)

func _on_area_2d_body_entered(body):
	if body.name == "ProjectileFriendly":
		body.queue_free()
		print("Enemy and projectile hit detected")
		destroyed.emit()
		queue_free()
