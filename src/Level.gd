extends Node2D

var platformer := true

func _unhandled_input(event):
  if event is InputEventKey:
    if event.pressed and event.scancode == KEY_ENTER:
      platformer = !platformer
