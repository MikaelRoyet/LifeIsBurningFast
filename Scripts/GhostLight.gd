extends Area2D

var target : Vector2
var speed = SPEED_MAX
var base_pos
const SPEED_MAX = 100



@onready var visionField = $VisionField/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = position
	GameManager.monsters.append(self)


func _physics_process(delta):
	if target != Vector2.ZERO:
		position += position.direction_to(target).normalized() * speed * delta
		look_at(target) #flipH si 180 deg?
		target = GameManager.player.position
	else:
		look_at(Vector2.ZERO)


func _on_vision_field_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.playSfx(GameManager.sfxGhostLight)
		target = body.position


func _on_vision_field_body_exited(body):
	if body.is_in_group("Player"):
		target = Vector2.ZERO


func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.playSfx(GameManager.sfxSouffle)
		body.death()


func start_moving():
	speed = SPEED_MAX
	
func stop_moving():
	speed = 0
