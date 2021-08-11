extends KinematicBody2D

var hp = 40
var move = Vector2()
var loc = Vector2()
var is_die = false
var player_in = false
var target = null
var move_speed = 0
var hit_counter = 0
var get_hurt = false
var teleport = false
var in_first_stage = true
var in_second_stage = false
var in_third_stage = false
var change_1 = false
var change_2 = false
var rand_loc_x = [1304, 1308, 1390, 1410, 1430, 1444, 1470, 1510, 1515, 1565, 1577, 1608]
var rand_loc_y = [-2128, -2100, -2085, -2020, -2095, -2077, -2068, -2060, -2050, -2044, -2030, -2000,]
var rand_loc_y_2 = [-2544, -2520, -2510, -2533, -2500, -2498, -2470, -2465, -2444, -2430, -2405, -2384]
var rand_loc_y_3 = [-2896, -2877, -2850, -2836, -2821, - 2808, -2800, -2785, - 2775, -2792, -2768]
var frostbal = preload("res://tile_sets/frostball.tscn")
signal die
signal meghalt

func _ready():
	$pos_change_1.start()

func _physics_process(delta):
	if hp == 2:
		emit_signal("die")
		$hp_bar.hide()
		$hurtbox.set_collision_mask_bit(5, false)
		$hurtbox/CollisionShape2D.disabled = true
		$shot_timer.stop()
		$pos_change_3.stop()
		is_die = true
		if is_die == true:
			$AnimatedSprite.play("die")
	if target:
		player_in = true
		move = global_position.direction_to(target.global_position)
		move_and_collide(move * move_speed * delta)
	else:
		player_in = false
	if player_in != false and get_hurt == false and teleport == false and is_die == false:
		$AnimatedSprite.play("shot")
	elif player_in == false and get_hurt == false and teleport == false and is_die == false:
		$AnimatedSprite.play("idle")
	elif player_in == false and get_hurt == true and teleport == false and is_die == false:
		$AnimatedSprite.play("hurt")
	elif player_in == true and get_hurt == true and teleport == false and is_die == false:
		$AnimatedSprite.play("hurt")
	if move.x < 0:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1
	if hit_counter == 10:
		change_1 = true
		$pos_change_1.stop()
		teleport = true
		if teleport == true and change_1 == true:
			$AnimatedSprite.play("teleport")
			$hurtbox.set_collision_mask_bit(5, false)
		in_first_stage = false
		in_second_stage = true
	if hit_counter == 21:
		change_2 = true
		$pos_change_2.stop()
		teleport = true
		if teleport == true and change_2 == true:
			$AnimatedSprite.play("teleport")
			$hurtbox.set_collision_mask_bit(5, false)
		in_second_stage = false
		in_third_stage = true

func _on_hurtbox_area_entered(area):
	get_hurt = true
	$hp_bar.value -= 1
	hp -= 1
	hit_counter += 1
	if hp == 2:
		get_node("/root/Sounds/kio_die").play()

func _on_hurtbox_area_exited(area):
	get_hurt = false

func _on_player_detector_body_entered(body):
	target = body
	$shot_timer.start()

func _on_player_detector_body_exited(body):
	target = null
	$shot_timer.stop()

func _on_pos_change_1_timeout():
	teleport = true
	if teleport == true:
		$AnimatedSprite.play("teleport")
		$hurtbox.set_collision_mask_bit(5, false)


func _on_pos_change_2_timeout():
	teleport = true
	if teleport == true:
		$AnimatedSprite.play("teleport")
		$hurtbox.set_collision_mask_bit(5, false)

func _on_pos_change_3_timeout():
	teleport = true
	if teleport == true:
		$AnimatedSprite.play("teleport")
		$hurtbox.set_collision_mask_bit(5, false)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "teleport" and change_1 == true:
		teleport = false
		change_1 = false
		hit_counter += 1
		position.x = 1304
		position.y = -2520
		$pos_change_2.start()
	elif $AnimatedSprite.animation == "teleport" and change_2 == true:
		teleport = false
		change_2 = false
		hit_counter += 1
		position.x = 1456
		position.y = -2880
		$pos_change_3.start()
	if $AnimatedSprite.animation == "teleport" and in_first_stage == true:
		teleport = false
		teleport_1()
	elif $AnimatedSprite.animation == "teleport" and in_second_stage == true:
		teleport = false
		teleport_2()
	elif $AnimatedSprite.animation == "teleport" and in_third_stage == true:
		teleport = false
		teleport_3()
	if $AnimatedSprite.animation == "die":
		emit_signal("meghalt")
		queue_free()


func teleport_1():
	position.x = rand_loc_x[randi() % rand_loc_x.size()]
	position.y = rand_loc_y[randi() % rand_loc_y.size()]
	$hurtbox.set_collision_mask_bit(5, true)
	$pos_change_1.start()
	
func teleport_2():
	position.x = rand_loc_x[randi() % rand_loc_x.size()]
	position.y = rand_loc_y_2[randi() % rand_loc_y_2.size()]
	$hurtbox.set_collision_mask_bit(5, true)
	$pos_change_2.start()

func teleport_3():
	position.x = rand_loc_x[randi() % rand_loc_x.size()]
	position.y = rand_loc_y_3[randi() % rand_loc_y_3.size()]
	$hurtbox.set_collision_mask_bit(5, true)
	$pos_change_3.start()


func _on_hurtbox_body_entered(body):
	get_hurt = true

func _on_hurtbox_body_exited(body):
	get_hurt = false

func _on_shot_timer_timeout():
	var x = frostbal.instance()
	get_parent().add_child(x)
	x.position = $AnimatedSprite/Position2D.global_position
