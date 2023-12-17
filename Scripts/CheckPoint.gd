extends Area2D

@onready var respawnPoint = $RespawnPoint
@onready var lamp = $Lamp
@onready var particles = $Particles
@export var orderCP = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	lamp.sprite.visible = false
	lamp.is_in_cp = true
	lamp.particles.visible = false
	particles.visible = false
	if orderCP == 0:
		GameManager.checkpoint = self
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if GameManager.checkpoint != self:
			GameManager.playSfx(GameManager.sfxCheckPoint)
			GameManager.player_in_cp(self)
			particles.visible = true
			


func _on_body_exited(body):
	if body.is_in_group("Player"):
		GameManager.player_out_cp()
