extends Node2D

export var platformer := true

onready var player := $Player

func _ready():
  var size = OS.get_real_window_size()
  if size.x == 320:
    OS.set_window_size(size * 2)
    OS.center_window()

func _unhandled_input(event):
  if event is InputEventKey:
    if event.pressed:
      match event.scancode:
        KEY_ENTER:
          platformer = !platformer
          player.change_gamestyle()
        KEY_R:
          get_tree().reload_current_scene()
        KEY_ESCAPE:
          get_tree().quit()
        
