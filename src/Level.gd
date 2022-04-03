extends Node2D

export var platformer := true

onready var player := $Player

func _unhandled_input(event):
  if event is InputEventKey:
    if event.pressed and event.scancode == KEY_ENTER:
      platformer = !platformer
      player.change_gamestyle()
