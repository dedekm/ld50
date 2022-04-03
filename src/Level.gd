extends Node2D

export var platformer := true

onready var player := $Player

func _ready():
  var size = OS.get_real_window_size()
  OS.set_window_size(size * 4)
  OS.center_window()

func _unhandled_input(event):
  if event is InputEventKey:
    if event.pressed and event.scancode == KEY_ENTER:
      platformer = !platformer
      player.change_gamestyle()
