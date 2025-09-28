extends Node
var vitorias : int = load_file()
var choice : int = 0
const file : String = "res://Campo-Minado/data/vitorias-seguidas.txt"
const explosion : Resource = preload("res://Campo-Minado/scenes/explosion.tscn")
const tile : Resource = preload("res://Campo-Minado/scenes/tile.tscn")
const hole : Resource = preload("res://Campo-Minado/scenes/hole.tscn")
const bomb : Resource = preload("res://Campo-Minado/scenes/bomb.tscn")
const banner : Resource = preload("res://Campo-Minado/scenes/banner.tscn")
const one : Resource = preload("res://Campo-Minado/assets/sprites/spr_one.png")
const two : Resource = preload("res://Campo-Minado/assets/sprites/spr_two.png")
const three : Resource = preload("res://Campo-Minado/assets/sprites/spr_three.png")
const four : Resource = preload("res://Campo-Minado/assets/sprites/spr_four.png")
const five : Resource = preload("res://Campo-Minado/assets/sprites/spr_five.png")
const six : Resource = preload("res://Campo-Minado/assets/sprites/spr_six.png")
const seven : Resource = preload("res://Campo-Minado/assets/sprites/spr_seven.png")
const main : String = "res://Campo-Minado/scenes/main.tscn"
const win : String = "res://Campo-Minado/scenes/win.tscn"
const lose : String = "res://Campo-Minado/scenes/lose.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_file() -> int:
	var _file : FileAccess = FileAccess.open(file,FileAccess.READ)
	if _file:
		if _file.get_length() > 0:
			vitorias = _file.get_as_text().to_int()
		else:
			print('Arquivo vazio.')
	_file.close()
	return vitorias
