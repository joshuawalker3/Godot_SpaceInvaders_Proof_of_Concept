extends Node

var score = 0
@export var enemy_scene: PackedScene
@export var projectile_scene: PackedScene
#var screen_size
var enemy_count = 0
var total_enemy_count = 0 
var level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Menu.stop()
	$InGame.play()
	reset_to_defaults()
	$HUD.update_score(score)
	display_level()
	await get_tree().create_timer(1.0).timeout
	$Player.start($StartingPosition.position)
	spawn_enemies(3, $EnemySpawnStart.position)
	
func next_level(): 
	$InGame.stop()
	$LevelUp.play()
	$Player.set_player_shoot(false)
	
	print("Next level")
	total_enemy_count = 0
	level += 1
	
	display_level()
	await get_tree().create_timer(2.08).timeout
	
	$Player.set_player_shoot(true)
	spawn_enemies(3, $EnemySpawnStart.position)
	$InGame.play()


func game_over():
	$Player.hide()
	$Player.disable_shoot()
	get_tree().call_group_flags(1,"Enemies", "pause_movement")
	get_tree().call_group_flags(1,"friendly_projectiles", "queue_free")
	$InGame.stop()
	$GameOver.play()
	await get_tree().create_timer(2.71).timeout
	get_tree().call_group_flags(1,"Enemies", "queue_free")
	$HUD.show_game_over()
	$Menu.play()
	

func spawn_enemies(rows, start_position):
	for i in rows:
		for ii in 7:
			var enemy = enemy_scene.instantiate()
			var enemy_position = Vector2()
			enemy_position.y = start_position.y
			enemy_position.x = start_position.x + 90 * ii
			enemy.spawn_enemy(enemy_position, level, $StartingPosition.position.y)
			if (!enemy.destroyed.is_connected(_on_enemy_destroyed)):
				#Connect signal from enemy
				enemy.destroyed.connect(_on_enemy_destroyed)
			if (!enemy.change_direction.is_connected(_on_enemy_change_direction)):
				enemy.change_direction.connect(_on_enemy_change_direction)
			if (!enemy.bottom_reached.is_connected(game_over)):
				enemy.bottom_reached.connect(game_over)
			add_child(enemy)
			enemy_count += 1
		
		start_position.y += 100
	total_enemy_count = enemy_count

func _on_enemy_destroyed():
	score += 5
	$HUD.update_score(score)
	enemy_count -= 1
	if enemy_count > 0:
		get_tree().call_group_flags(2,"Enemies", "increment_speed", total_enemy_count, enemy_count)
	else:
		next_level()

func _on_enemy_change_direction():
	#print($DirectionTimer.get_time_left())
	if $DirectionTimer.is_stopped():
		get_tree().call_group_flags(2,"Enemies", "_on_change_direction")
		$DirectionTimer.start()

func _on_direction_timer_timeout():
	$DirectionTimer.stop()

func _on_hud_start_game():
	$HUD.show_message("Get Ready")
	await get_tree().create_timer(1.0).timeout
	new_game() 

func display_level():
	var level_display = "Level " + str(level)
	$HUD.show_message(level_display)

func reset_to_defaults():
	score = 0
	enemy_count = 0
	level = 1
