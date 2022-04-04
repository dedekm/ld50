extends Node2D

export var platformer := true
export var killzone := 672

onready var player := $Player

func _ready():
  var size = OS.get_real_window_size()

  if size.x < 640:
    OS.set_window_size(size * 4)
    OS.center_window()

  randomize()

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

func end():
  print("THE END")
