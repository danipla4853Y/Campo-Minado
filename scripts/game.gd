extends Node2D

const grid_x : int = 1
const grid_y : int = 1

var tiles_list : Array = []
var bombs_list : Array = []
var holes_list : Array = []
var nobomb_list : Array = []

var grid : Array = select_grid(Global.choice)
var click_count : int = 0
var bombs : int = round((grid[1]*grid[0])*0.15)
var first_click : Array = []

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	set_tiles()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if click_count == 1:
		bombs_position(bombs)
		click_count += 1
		for _tile : Array in tiles_list:
			var _x : int = _tile[0].position.x
			var _y : int  = _tile[0].position.y
			if [_tile[1],_tile[2]] in bombs_list:
				_tile[3] = true
				var _bomb : Object= instanciate_obj(Global.bomb,_x,_y)
				_bomb.name = 'B' + str(tiles_list.find(Global.tile)+1)
				add_child(_bomb)
			else:
				var _hole : Object= instanciate_obj(Global.hole,_x,_y)
				_hole.name = 'H' + str(tiles_list.find(Global.tile)+1)
				holes_list.append([_hole,_tile[1],_tile[2]])
				add_child(_hole)
				
		
		holes_count()

func _input(_event: InputEvent) -> void:
	check_mouse_click()

func set_tiles() -> void:
	# Variables
	var centralize_x :int = (DisplayServer.window_get_size().x/2.0) - (32*(grid[0]/2))
	var centralize_y :int = (DisplayServer.window_get_size().y/2.0) - (32*(grid[1]/2))
	var _x:int = centralize_x
	var _y:int = centralize_y
	var _grid_x:int = grid_x
	var _grid_y:int = grid_y 
	
	#Definir a posição das bombas
	#Posicionar tiles
	for i in range(1,grid[0]*grid[1]+1):
		var _tile : Object = instanciate_obj(Global.tile,_x,_y)
		_tile.name = 'T' + str(i)
		tiles_list.append([_tile,_grid_x,_grid_y,false])
		
		add_child(_tile)
			
		#Posicionamento
		_grid_x +=1
		_x += 32 
		
		if i % grid[0] == 0 :
			_y += 32
			_x = centralize_x
			_grid_x = grid_x
			_grid_y += 1

func check_mouse_click() -> void:
	var click : bool = Input.is_action_just_released("left_mouse_button", true) 
	var mouse_position : Vector2 = get_viewport().get_mouse_position()

	if click == true:
		for _tile : Array in tiles_list:
			var tilex : int = _tile[0].position.x
			var tiley : int= _tile[0].position.y
			
			#Esquações booleanas
			var check_x : bool= (tilex-16 < mouse_position.x and mouse_position.x < (tilex + 16) == true)
			var check_y : bool= (tiley-16 < mouse_position.y and mouse_position.y < (tiley + 16) == true)
			
			if  check_x and check_y == true:
				_tile[0].free()
				tiles_list.erase(_tile)
				if _tile[3]:
					game_over()
				elif click_count == 0:
					var first_hole : Object = instanciate_obj(Global.hole,tilex,tiley)
					first_hole.name = 'H' + str(tiles_list.find(Global.tile)+1)
					add_child(first_hole)
					first_click = _tile
					deny_bombs(_tile)
					
					click_count += 1
				
				elif len(tiles_list) == bombs:
					game_win()

func instanciate_obj(obj : Resource,_x : int,_y : int) -> Object:
	var _tile : Object = obj.instantiate()
	_tile.position.x = _x
	_tile.position.y = _y
	return _tile

func count_bombs(count : int,i : int) -> int:
	count += test_bombs(i,1)
	count += test_bombs(i,0)
	count += test_bombs(i,-1)
	return count

func select_grid(game_dif : int) -> Array:
	
	if game_dif == 1:
		return [6,10]
		
	elif game_dif == 2:
		return [8,12]
		
	elif game_dif == 3:
		return [10,14]
	else:
		return [4,6]
		
func game_over() -> void:
	Global.vitorias = 0
	save_file()
	get_tree().change_scene_to_file(Global.main)

func game_win() -> void:
	Global.vitorias += 1
	save_file()
	get_tree().change_scene_to_file(Global.main)

func save_file() -> void:
	var _file : FileAccess = FileAccess.open(Global.file,FileAccess.WRITE)
	if _file:
		_file.store_string(str(Global.vitorias))
		
	else:
		print('Arquivo nao encontrado')

func test_bombs(i : int,y : int) -> int:
	var count : int = 0
	for x in range(-1,2):
		var _grid_x_hole : int = holes_list[i][1]+x
		var _grid_y_hole : int = holes_list[i][2]+y
		for f in range(len(bombs_list)):
			var bomb_x : int= bombs_list[f][0]
			var bomb_y : int = bombs_list[f][1]
			if bomb_x == _grid_x_hole and bomb_y == _grid_y_hole :
				count += 1
				
	return count

func bombs_position(_bombs : int) -> Array:
	
	var a : int = 0

	while a < (_bombs):
		var place_x : int = randi_range(1,grid[0])
		var place_y : int =  randi_range(1,grid[1])
		var place : Array = [place_x,place_y]
		
		if place in bombs_list or place in nobomb_list:
			continue
		else:
			bombs_list.append(place)
			
			a += 1
	return bombs_list

func deny_bombs(first_tile: Array) -> Array:
	for y in range(-1,2):
		for x in range(-1,2):
			var x_tile : int = first_tile[1]+x
			var y_tile :int = first_tile[2]+y
			
			nobomb_list.append([x_tile,y_tile])
	return nobomb_list

func holes_count() -> void:
	#Textura dos holes
	for i in range(len(holes_list)):
		var count : int = 0
		count = count_bombs(count,i)
		var spr : Sprite2D = holes_list[i][0].get_node("Sprite")
		match count: 
			
			1:
				spr.set_texture(Global.one)
			2:
				spr.set_texture(Global.two)
			3:
				spr.set_texture(Global.three)
			4:
				spr.set_texture(Global.four)
			5:
				spr.set_texture(Global.five)
			6:
				spr.set_texture(Global.six)
			7:
				spr.set_texture(Global.seven)
