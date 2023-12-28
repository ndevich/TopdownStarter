extends Control

@export var money_label : Label
@export var healthbar : ProgressBar

func _ready():
	healthbar.max_value = GameManager.player_health;
	healthbar.value = GameManager.player_health;
	
func _process(_delta):
	money_label.text = "Coins: " + "%d" % GameManager.money
	healthbar.value = GameManager.player_health;

