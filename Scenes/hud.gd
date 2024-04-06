extends CanvasLayer

var gameTitle = "Generic Game Title"

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over!")
	await $MessageTimer.timeout #wait for timer
	
	$Message.text = "Generic Game Title"
	$Message.show()
	#Make a one-shot timer and wait for it to timeout
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
	
func update_score(score):
	$Score.text = str(score)
	
func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
