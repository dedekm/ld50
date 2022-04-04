extends Node2D

class_name Thing

export var dialog_name : String

onready var height : int = $InteractionArea/CollisionShape2D.shape.extents.y

func _ready():
  add_to_group("things")

func use(player: Node2D):
  $AnimatedSprite.play("occupied")

func use_stopped(player: Node2D):
  $AnimatedSprite.play("empty")
