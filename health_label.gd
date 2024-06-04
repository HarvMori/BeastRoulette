extends Label

@export var main_node : Node3D

func update_health():
	text = str("Здоровье Дилера : ", main_node.dealer_health, '\n', "Здоровье игрока : ", main_node.player_health)
