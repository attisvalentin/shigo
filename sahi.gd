extends KinematicBody2D

var target = null
var move = Vector2()
var hp = 100
var move_speed = 50
var hitcounter = 0
var is_die = false
var player_in = false
var player_can_hurt = false
var frostbal = preload("res://tile_sets/lightball.tscn")
signal pos_change
signal dead
signal end

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if target:
		player_in = true
		move = global_position.direction_to(target.global_position)
		move_and_collide(move * move_speed * delta)
	else:
		player_in = false
	if hp == 3:
		$attack.stop()
		is_die = true
		emit_signal("dead")
		die()
	elif player_in != false and player_can_hurt == false and is_die == false:
		$AnimatedSprite.play("move")
	elif player_in == false and player_can_hurt == false and is_die == false:
		$AnimatedSprite.play("idle")
	elif player_in == false and player_can_hurt == true and is_die == false:
		$AnimatedSprite.play("shot")
	if move.x < 0:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1
	if player_can_hurt == true:
		$player_detector.set_collision_mask_bit(1, false)
		$player_detector/CollisionPolygon2D.disabled = true
	else:
		$player_detector.set_collision_mask_bit(1, true)
		$player_detector/CollisionPolygon2D.disabled = false
	if hitcounter == 20:
		emit_signal("pos_change")
		hitcounter += 1
	if hitcounter == 40:
		emit_signal("pos_change")
		hitcounter += 1
	if hitcounter == 80:
		emit_signal("pos_change")
		hitcounter += 1

func die():
	$AnimatedSprite.play("die")
	$ProgressBar.hide()

func _on_player_detector_body_entered(body):
	$player_exit.stop()
	target = body

func _on_player_detector_body_exited(body):
	target = null


func _on_hurtbox_area_entered(area):
	hp -= 1
	$ProgressBar.value -= 1
	hitcounter += 1
	if hp == 3:
		get_node("/root/Sounds/last").play()


func _on_player_can_hurt_body_entered(body):
	player_can_hurt = true
	$attack.start()

func _on_attack_timeout():
	var x = frostbal.instance()
	get_parent().add_child(x)
	x.position = $firepos.global_position

func _on_player_can_hurt_body_exited(body):
	$player_exit.start()
	$attack.stop()


func _on_player_exit_timeout():
	player_can_hurt = false
