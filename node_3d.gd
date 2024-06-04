extends Node3D

# Инициализация переменных
var bull = [true, false] # Пример начального состояния пуль
var bullets_num = 4
var targets = ["Игрок", "Дилер"]
var last_survived = true
var player_health = 6
var dealer_health = 6


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
	var risk_level = bull.count(true) / float(bull.size())
	if dealer_health >= 3:
		risk_level -= 0.1
	else:
		risk_level += 0.1
	var dealer_behavior = randi() % 100
	if dealer_behavior < 30:
		print("Дилер кажется нервным.")
		risk_level -= 0.1 
	elif dealer_behavior > 70:
		print("Дилер выглядит уверенно.")
		risk_level += 0.1 
	if last_survived and risk_level < 0.7:
		risk_level += 0.2 
	print("Цель дилера: ", target)
	if dealer_behavior == 50:
		print("Дилер сделал ошибку!")
		target = "Дилер"

func player_turn(target):
	if bull.size() > 0:
		var bullet = bull.pop_front()
		if bullet:
			print("Выстрел целым патроном!")
			if target == "Игрок":
				player_health -= 1
				if player_health <= 0:
					return
			elif target == "Дилер":
				dealer_health -= 1
				if dealer_health <= 0:
					return
		else:
			print("Клик! Пустой патрон.")
			dealer_turn(target) # Добавлен вызов функции dealer_turn с аргументом target
	else:
		print("Патроны закончились! Игра окончена.")

