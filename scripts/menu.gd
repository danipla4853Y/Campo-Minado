extends Control
const game : String = 'res://Campo-Minado/scenes/game.tscn'
const secret : Resource = preload("res://Campo-Minado/assets/sprites/spr_secret.png")
var count_secret : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(game)

func _on_option_button_item_selected(index: int) -> void:
	print(index)
	Global.choice = 0
	Global.choice = index

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_button_pressed() -> void:
	count_secret +=1
	if count_secret == 10:
		$Panel/Secret.show_behind_parent = false
		$VBoxContainer.visible = false
		$Panel/Label.visible = false
		$AnimalsAuuuuuuuuuu.play()
		
	if count_secret == 15:
		$Panel/Secret.show_behind_parent = true
		$VBoxContainer.visible = true
		$Panel/Label.visible = true
		$AnimalsAuuuuuuuuuu.stop()
		count_secret = 0
