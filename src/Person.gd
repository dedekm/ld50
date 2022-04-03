extends Node2D

class_name Person

export var portrait_name : String

var portrait : Texture

func _ready():
  if portrait_name:
    portrait = load("res://assets/portraits/%s.png" % [portrait_name])
  else:
    print("WARNING: %s: no portrait image!" % self)
