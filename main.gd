extends Node

var score = 0
@export var projectile_scene: PackedScene
@export var enemy_scene: PackedScene
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Player.start($StartingPosition.position)
	spawn_enemies(5, $EnemySpawnStart.position)


func game_over():
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
		for ii in 14:
			var enemy = enemy_scene.instantiate()
			var enemy_position = Vector2()
			enemy_position.y = start_position.y
			enemy_position.x = start_position.x + 75 * ii
			enemy.spawn_enemy(enemy_position)
			if (!enemy.destroyed.is_connected(_on_enemy_destroyed)):
				#Connect signal from enemy
				enemy.destroyed.connect(_on_enemy_destroyed)
			if (!enemy.change_direction.is_connected(_on_enemy_change_direction)):
				enemy.change_direction.connect(_on_enemy_change_direction)
			add_child(enemy)
		
		start_position.y += 100
	
func _on_enemy_destroyed():
	score += 5
	print(score)
	
func _on_enemy_change_direction():
	if $DirectionTimer.is_stopped():
		get_tree().call_group_flags(2,"Enemies", "_on_change_direction")
		$DirectionTimer.start()


func _on_direction_timer_timeout():
	$DirectionTimer.stop()
