extends RigidBody2D

var speed = 10
var direction = 1
var screen_size

signal change_direction
signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	screen_size = get_viewport_rect().size
	set_continuous_collision_detection_mode(0)
	position.y = 500


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var minBuffer = Vector2.ZERO
	var maxBuffer = Vector2.ZERO
	
	minBuffer.x = 35
	minBuffer.y = 35
	maxBuffer.x = screen_size.x - 35
	maxBuffer.y = screen_size.y - 35
	
	position.x += speed * direction * delta
	
	var unclamped_x_position = position.x
	
	position = position.clamp(minBuffer, maxBuffer)
	
	if unclamped_x_position != position.x:
		change_direction.emit()

func _on_change_direction():
	direction = -direction
	position.y += 20
	
func spawn_enemy(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	


func _on_body_entered(body):
	print("HIT")
