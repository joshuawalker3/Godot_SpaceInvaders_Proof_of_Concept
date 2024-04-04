extends Node

var score = 0
@export var enemy_scene: PackedScene
@export var projectile_scene: PackedScene
var screen_size
var enemy_count = 0
var total_enemy_count = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Player.start($StartingPosition.position)
	spawn_enemies(3, $EnemySpawnStart.position)


func game_over():
	get_tree().call_group_flags(2,"Enemies", "pause_movement")
	$Player.queue_free()
	print("Game over")
	
func _on_player_shoot():
	if get_tree().get_nodes_in_group("friendly_projectiles").size() == 0:
		var projectile = projectile_scene.instantiate()
	
		var projectile_spawn_location = Vector2.ZERO
	
		projectile.spawn_position($Player.position) 
		
		#print(projectile.name)
	
		add_child(projectile)

func spawn_enemies(rows, start_position):
	for i in rows:
		for ii in 7:
			var enemy = enemy_scene.instantiate()
			var enemy_position = Vector2()
			enemy_position.y = start_position.y
			enemy_position.x = start_position.x + 90 * ii
			enemy.spawn_enemy(enemy_position)
			if (!enemy.destroyed.is_connected(_on_enemy_destroyed)):
				#Connect signal from enemy
				enemy.destroyed.connect(_on_enemy_destroyed)
			if (!enemy.change_direction.is_connected(_on_enemy_change_direction)):
				enemy.change_direction.connect(_on_enemy_change_direction)
			add_child(enemy)
			enemy_count += 1
		
		start_position.y += 100
	total_enemy_count = enemy_count

func _on_enemy_destroyed():
	score += 5
	enemy_count -= 1
	if enemy_count > 0:
		get_tree().call_group_flags(2,"Enemies", "increment_speed", total_enemy_count, enemy_count)
	print(score)
	
	
func _on_enemy_change_direction():
	#print($DirectionTimer.get_time_left())
	if $DirectionTimer.is_stopped():
		get_tree().call_group_flags(2,"Enemies", "_on_change_direction")
		$DirectionTimer.start()

func _on_direction_timer_timeout():
	$DirectionTimer.stop()
