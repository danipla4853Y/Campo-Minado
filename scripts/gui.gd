extends Control
const file : String = "res://Campo-Minado/data/vitorias-seguidas.txt"
var vitorias: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	vitorias = load_file()
	$CanvasLayer/Label.text = str(vitorias)
	

func load_file() -> int:
	var _file : FileAccess = FileAccess.open(file,FileAccess.READ)
	if _file:
		if _file.get_length() > 0:
			vitorias = _file.get_as_text().to_int()
		else:
			print('Arquivo vazio.')
	_file.close()
	return vitorias
