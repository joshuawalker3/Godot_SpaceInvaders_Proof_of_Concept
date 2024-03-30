extends Area2D

var speed
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	speed = -screen_size.y
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	if position.y <= 0:
		queue_free()
		#print("Projectile gone") 
	#position.y += 0
	
func spawn_position(pos):
	position.x = pos.x
	position.y = pos.y - 50
