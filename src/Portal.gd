extends Node2D

func _on_PlatformerArea_body_entered(body):
  if body.name == "Player" and body.platformer:
    body.start_monolog()

func _on_EndGameArea_body_entered(body):
  if body.name == "Player":
    body.level.end()
  
