extends KinematicBody2D

signal get_hurt
var fireball = preload("res://tile_sets/fireball.tscn")
var hp = 30
var location = Vector2()

func _ready():
	$AnimatedSprite.play("idle")
	$hurt.set_collision_layer_bit(6, false)


func _on_hurt_area_entered(area):
	emit_signal("get_hurt")


func _on_player_detector_body_entered(body):
	#if body.name == "player":
	$shot_timer.start()
	$fast_shot_timer.start()


func _on_shot_timer_timeout():
	var x = fireball
	location.x = 0
	location.y = 0
	var scene = fireball.instance()
	scene.position = location
	add_child(scene)


func _on_fast_shot_timer_timeout():
	$shot_timer.stop()
	$fast_shot.start()
	$fast_stop.start()


func _on_fast_shot_timeout():
	var x = fireball
	location.x = 0
	location.y = 0
	var scene = fireball.instance()
	scene.position = location
	add_child(scene)


func _on_fast_stop_timeout():
	$fast_shot.stop()
	$shot_timer.start()
	$fast_shot_timer.start()


func _on_YSort_disabled_player_detector():
	$fast_shot_timer.start()
	$shot_timer.stop()
	$player_detector.set_collision_mask_bit(1, false)
	$player_detector/CollisionShape2D.disabled = true


func _on_YSort_enabled_player_detector():
	$player_detector.set_collision_mask_bit(1, true)
	$player_detector/CollisionShape2D.disabled = false


func _on_YSort_kio_die():
	$hp_bar.hide()
