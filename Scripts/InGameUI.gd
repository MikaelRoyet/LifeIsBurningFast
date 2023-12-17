extends Control

var life_bar : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	life_bar = $ProgressBar
	var emmiter = GameManager
	emmiter.signal_life.connect(setLife)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setLife(life):
	life_bar.value = life
