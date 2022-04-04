extends Node2D

class_name Person

export var portrait_name : String
export var dialog_name : String

var portrait : Texture

func _ready():
  if portrait_name:
    portrait = load("res://assets/portraits/%s.png" % [portrait_name])
  else:
    print("WARNING: %s: no portrait image!" % self)
    
  if !dialog_name:
    print("WARNING: %s: no dialog!" % self)
