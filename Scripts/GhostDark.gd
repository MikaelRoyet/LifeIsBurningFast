extends Area2D

var target : Vector2
var targetLamp : Vector2
var lamp
var speed = SPEED_MAX
var is_light = false
var target_hiding = false
var base_pos
const SPEED_MAX = 100



@onready var visionField = $VisionField/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pos = position
	GameManager.monsters.append(self)



func _physics_process(delta):
	if target != Vector2.ZERO && !target_hiding:
		position += position.direction_to(target).normalized() * speed * delta
		look_at(target) #flipH si 180 deg?
		target = GameManager.player.position
	elif targetLamp != Vector2.ZERO && lamp != null && lamp.is_lit :
		print(targetLamp)
		position += position.direction_to(targetLamp).normalized() * speed * delta
		look_at(targetLamp) #flipH si 180 deg?
			


func _on_vision_field_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.playSfx(GameManager.sfxGhostDark)
		target = body.position

func _on_vision_field_area_entered(area):
	if area.is_in_group("Lamp"):
		if area.is_in_cp:
			targetLamp = area.get_global_pos()
		else:
			targetLamp = area.position
		lamp = area


func _on_vision_field_body_exited(body):
	if body.is_in_group("Player"):
		target = Vector2.ZERO


func _on_vision_field_area_exited(area):
	if area.is_in_group("Lamp"):
		targetLamp = Vector2.ZERO
		lamp = null

func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.playSfx(GameManager.sfxSouffle)
		body.death()


func start_moving():
	speed = SPEED_MAX
	target_hiding = false
	
func stop_moving():
	target_hiding = true
	speed = 0

func start_moving_to_lamp():
	speed = SPEED_MAX



