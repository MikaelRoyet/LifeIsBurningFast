extends Node2D

signal signal_life

var tileMap : TileMap
var player : CharacterBody2D
var checkpoint
var inGameMenu


var monsters = []

#Audio
var musicPlayer : AudioStreamPlayer
var sfxPlayers

var sfxMenuMove = load("res://Audio/Sfx/plop1.wav")
var sfxMenuclic = load("res://Audio/Sfx/plop1.wav")
var sfxWalk = load("res://Audio/Sfx/plop1.wav")
var sfxLamp = load("res://Audio/Sfx/plop1.wav")
var sfxCheckPoint = load("res://Audio/Sfx/plop1.wav")
var sfxGhostLight = load("res://Audio/Sfx/plop1.wav")
var sfxGhostDark = load("res://Audio/Sfx/plop1.wav")
var sfxWater = load("res://Audio/Sfx/plop1.wav")
var sfxSouffle = load("res://Audio/Sfx/plop1.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_tile_info(point : Vector2):
	return tileMap.get_tile(point)
	
func burn_tile(tile):
	tileMap.burn(tile)

func is_tile_water(tile):
	return tileMap.is_tile_water(tile)


func respawn():
	if checkpoint != null:
		var rs =  checkpoint.respawnPoint
		player.position = rs.to_global(rs.position)
	for monster in monsters:
		monster.position = monster.base_pos

func sendLifeToUI(life):
	emit_signal("signal_life", life)

func player_in_cp(cp):
	checkpoint = cp
	player.current_life = player.LIFE
	player.is_in_cp = true

func player_out_cp():
	player.current_life = player.LIFE
	player.is_in_cp = false

func playSfx(audioFile):
	sfxPlayers.playSound(audioFile)
