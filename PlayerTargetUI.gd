extends Control

# Сигнал, отправляемый после выбора игрока
signal player_made_choice(target)

# Переменные для хранения узлов кнопок
var dealer_button: Button
var player_button: Button
var player_target = ""

func _ready():
	# Получаем существующие кнопки из сцены
	dealer_button = get_node("/root/Node3D/Panel/VBoxContainer3/Dealer_button")
	player_button = get_node("/root/Node3D/Panel/VBoxContainer4/Player_button") 

func _on_dealer_button_pressed():
	self.player_target = "Дилер"
	emit_signal("player_made_choice", player_target)
	hide_selection_buttons() # Скрываем кнопки после выбора

func _on_player_button_pressed():
	self.player_target = "Игрок"
	emit_signal("player_made_choice", player_target)
	hide_selection_buttons() # Скрываем кнопки после выбора

# Функция для скрытия кнопок выбора
func hide_selection_buttons():
	dealer_button.hide()
	player_button.hide()

# Остальные функции остаются без изменений
