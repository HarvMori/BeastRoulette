extends Node3D

# Инициализация переменных
var bull = [false, true, true] # Пример начального состояния пуль
var bullets_num = 4
var targets = ["Игрок", "Дилер"]
var last_survived = true
var player_health = 6
var dealer_health = 6
var risk_level : float

signal dealer_turn_ended
signal player_turn_ended
signal heath_updated

func _ready():
	print("test1")
	load_bullets()
	dealer_turn("Игрок")

func load_bullets():
	print("Всего патронов: ", bullets_num)
	for i in range(bullets_num - bull.size()):
		bull.append(randi() % 2 == 0)
	print("Заряженых патронов: ", bull.count(true))
	print("Пустых патронов: ", bull.count(false))
	bull.shuffle()
	print("Патроны после перемешивания: ", bull)

func dealer_turn(target):
	risk_level = bull.count(true) / float(bull.size())
	var dealer_behavior = calculate_risk()
	
	last_survived = true
	
	target = handle_target_choosing(dealer_behavior)
	
	print("Цель дилера: ", target)
	print("Уровень риска: ", risk_level)
	print(bull.count(true))

	if bull.size() > 0 and bull.count(true) > 0:
		var bullet = bull.pop_front()
		if bullet:
			dealer_shoot_target(target)
			if player_health <= 0 or dealer_health <= 0:
				print("Игра закончена")
				return
		else:
			dealer_empty(target)
	else:
		dealer_no_bullets(target)


func player_turn(target):
	if bull.size() > 0 and bull.count(true) > 0:
		var bullet = bull.pop_front()
		if bullet:
			if target == "Игрок":
				print("Вы стреляете в себя!")
				print("Патроны у вас: ", bull)
				player_health -= 1
				heath_updated.emit()
				player_turn_ended.emit()
				target = null
				dealer_turn(target)
				
			elif target == "Дилер":
				print("Вы стреляете в Дилера!")
				print("Патроны у вас: ", bull)
				dealer_health -= 1
				last_survived = false
				player_turn_ended.emit()
				heath_updated.emit()
				target = null
				dealer_turn(target)
		else:
			if target == "Игрок":
				print("Клик! Вы знали!!.")
				print("Патроны у вас: ", bull)
				player_turn_ended.emit() 
				target = null
				player_turn(target)
				return
			elif target == "Дилер":
				print("Клик! Сегодня не ваш день.")
				print("Патроны у вас: ", bull)
				player_turn_ended.emit()
				target = null
				dealer_turn(target)
	else:
		player_turn_ended.emit()
		if bull.count(true) <= 0:
			print("Нету целых патронов!")
			bull = [false, true]
		else:
			print("Патроны закончились!")
			bull = [false, true]
		load_bullets()


	
func calculate_risk() -> int:
	if dealer_health <= 3:
		risk_level -= 0.1
	else:
		risk_level += 0.1
	var dealer_behavior = randi() % 100
	if dealer_behavior < 40:
		print("Дилер кажется нервным.")
		risk_level -= 0.1 
	elif dealer_behavior > 80:
		print("Дилер выглядит уверенно.")
		risk_level += 0.1 
	if last_survived and risk_level < 0.7:
		risk_level += 0.2 
	return dealer_behavior

func handle_target_choosing(dealer_behavior) -> String :
	var target : String
	if dealer_behavior == 50:
		print("Дилер сделал ошибку!")
		target = "Дилер"
	if dealer_health < 1:
		if bull.count(true):
			target = "Игрок"
		else:
			target = "Дилер"
	elif risk_level > 0.5:
		target = "Игрок"
	else:
		target = "Дилер"
	return target

func dealer_shoot_target(target : String):
	if target == "Игрок":
		print("Дилер стреляет в вас!")
		print("Патроны: ", bull)
		player_health -= 1
		heath_updated.emit()
		if player_health <= 0:
			print("Игрок умер")
	elif target == "Дилер":
		print("Дилер стреляет в себя! Ауч!")
		print("Патроны: ", bull)
		dealer_health -= 1
		last_survived = false
		heath_updated.emit()
		if dealer_health <= 0:
			print("Дилер умер")
	dealer_turn_ended.emit()

func dealer_empty(target):
	if target == "Игрок":
		print("Патроны: ", bull)
		print("Клик! Вам повезло!.")
		dealer_turn_ended.emit()
	
	elif target == "Дилер":
		print("Клик! Дилер ходит снова..")
		dealer_turn_ended.emit()

func dealer_no_bullets(target):
	if bull.count(true) <= 0:
		print("Нету целых патронов!")
		bull = [false, true]
	else:
		print("Патроны закончились!")
		bull = [false, true]
	load_bullets()
	dealer_turn(target)
