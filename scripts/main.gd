extends Node2D

const tile = preload("res://scenes/tile.tscn")
const hole = preload("res://scenes/hole.tscn")
const bomb = preload("res://scenes/bomb.tscn")
const grid_x = 1
const grid_y = 1

var tiles_list = []
var bombs_list = []
var holes_list = []
# Called when the node enters the scene tree for the first time.
func _ready():
	set_tiles()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	check_mouse_click()

func set_tiles():
	# Variables
	var grid = select_grid('Easy')
	var _bombs = round((grid[1]*grid[0])*0.15)
	
	var centralize_x = (DisplayServer.window_get_size().x/2) - (32*(grid[1]/2))
	var centralize_y = (DisplayServer.window_get_size().y/2) - (32*(grid[0]/2))
	var _x = centralize_x
	var _y = centralize_y
	var _grid_x = grid_x
	var _grid_y = grid_y 
	
	#Definir a posição das bombas
	for i in range(_bombs+1):
		var place = randi_range(1,80)
		if place not in bombs_list:
			bombs_list.append(place)
	
	
	#Posicionar tiles
	for i in range(1,grid[0]*grid[1]+1):
		var _tile = instanciate_obj(tile,_x,_y,i)
		
		_tile.name = 'T' + str(i)
		
		if i in bombs_list:
			tiles_list.append([_tile,true,_grid_x,_grid_y])
		else:
			tiles_list.append([_tile,false,_grid_x,_grid_y])
			
		#Se tiver bomba
		if tiles_list[i-1][1]:
			var _bomb = instanciate_obj(bomb,_x,_y,i)
			_bomb.name = 'B' + str(i)
			
			#Processo para substituir os números pelas próprias bombas
			bombs_list.append([_bomb,_grid_x,_grid_y])
			bombs_list.erase(i)
			
			#Instanciar bomba
			add_child(_bomb)
		#Se não tiver bomba
		else:
			var _hole = instanciate_obj(hole,_x,_y,i)
			_hole.name = 'H' + str(i)
			
			#Instanciar hole
			add_child(_hole)
			holes_list.append([_hole,_grid_x,_grid_y])
			
		#Instanciar tile
		add_child(_tile)
		
		_grid_x +=1
		_x += 32 
		
		if i % grid[1] == 0 :
			_y += 32
			_x = centralize_x
			_grid_x = grid_x
			_grid_y += 1
			
	count_bombs()
func check_mouse_click ():
	var click = Input.is_action_just_released("left_mouse_button", true) 
	var mouse_position = get_viewport().get_mouse_position()
	
	if click:
		for tile in tiles_list:
			var tilex = tile[0].position.x
			var tiley = tile[0].position.y
		
			#Esquações booleanas
			var check_x = (tilex < mouse_position.x and mouse_position.x < (tilex + 32) == true)
			var check_y = (tiley < mouse_position.y and mouse_position.y < (tiley + 32) == true)
			
			if  check_x and check_y == true:
				#tile[0].free()
				#tiles_list.erase(tile)
				print('x = ', tile[2],'y = ',tile[3])
				#if tile[1]:
					#game_over()

func instanciate_obj(obj,_x,_y,i):
	var _tile = obj.instantiate()
	_tile.position.x = _x
	_tile.position.y = _y
	return _tile

func count_bombs():
	#Colocar coordenadas de cada tile como se fosse um grid na lista de tiles
	pass
	'''
	var count = 0
	for bomb in bombs_list:
		print(bomb[1])
		for a in range(8):
			if (bomb[1]+posbl_bombs[a]) >= 0:
				'''
func select_grid(game_dif):
	if game_dif == 'Easy':
		return [8,10]

	elif game_dif == 'Medium':
		return [10,12]
		
	else:
		return [12,14]			
			
				
		
			
				
			
		
			
		
		
		
		 
			
		
		
	
	

func game_over():
	get_tree().quit()
