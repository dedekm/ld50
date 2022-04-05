extends Node2D

export var platformer := true
export var killzone := 672

onready var player := $Player
onready var camera := $Camera
onready var platformer_camera_limit_bottom : int = $Camera.limit_bottom

var four_way_camera_limit_bottom := 1504

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
  player.movement_disabled = true
  player.visible = false
  $FadeOut.position = $Camera.position
  $FadeOut/AnimationPlayer.play('fade_out')
  $FadeOut.visible = true
