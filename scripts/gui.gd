extends Control
const file : String = "res://Campo-Minado/data/vitorias-seguidas.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLayer/Label.text = str(Global.vitorias)
	
