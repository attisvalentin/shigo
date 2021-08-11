extends KinematicBody2D

var speed = 50
var movement = Vector2.ZERO
var is_attack = false
var is_dash = false
var dashing = true
var is_die = false
var hp = 10
var up = true
var down = true
var right = true
var left = true
var aura_can_use = true
var shot_counter = 5
var location = Vector2()
export(PackedScene) var fireball
signal get_hit
signal die
signal dash_fade
signal shot_fade
signal full_die

func _ready():
	$aura.play("aura")

func _physics_process(delta):
	movement = Vector2.ZERO
	if  Input.is_action_pressed("ui_right") and is_attack == false and right == true:
		$Sprite.scale.x = 1
		movement.x = 1
		left = false
		down = false
		up = false
	elif Input.is_action_just_released("ui_right"):
		left = true
		down = true
		up = true
	if  Input.is_action_pressed("ui_left") and is_attack == false and left == true:
		$Sprite.scale.x = -1
		movement.x = -1
		right = false
		down = false
		up = false
	elif Input.is_action_just_released("ui_left"):
		right = true
		down = true
		up = true
	if  Input.is_action_pressed("ui_down") and is_attack == false and down == true:
		movement.y = 1
		right = false
		left = false
		up = false
	elif Input.is_action_just_released("ui_down"):
		right = true
		left = true
		up = true
	if  Input.is_action_pressed("ui_up") and is_attack == false and up == true:
		movement.y = -1
		right = false
		left = false
		down = false
	elif Input.is_action_just_released("ui_up"):
		right = true
		left = true
		down = true
	if movement != Vector2.ZERO and is_dash == false and is_die == false:
		$Sprite.play("run")
	else:
		if is_attack == false and is_dash == false and is_die == false:
			$Sprite.play("idle")

	if Input.is_action_just_pressed("attack"):
		$sword_swh.play()
		$Sprite.play("attack")
		is_attack = true
		$Sprite/attack/CollisionShape2D.disabled = false

	if Input.is_action_just_pressed("dash") and movement != Vector2.ZERO and dashing == true:
		is_dash = true
		dash()
		$dash_timer.start()

	
	if Input.is_action_just_pressed("shot"):
		$Sprite/hand.show()
		$hand_timer.start()
		if $Sprite.scale.x == -1:
			var scene_1 = fireball.instance() as fireball2
			get_parent().add_child(scene_1)
			scene_1.position = $Sprite/shot_pos.global_position
			if scene_1:
				scene_1.left()
		else:
			var scene_2 = fireball.instance() as fireball2
			get_parent().add_child(scene_2)
			scene_2.position = $Sprite/shot_pos.global_position
			if scene_2:
				scene_2.right()
	
	if Input.is_action_just_pressed("aura_block") and aura_can_use == true:
		$aura_audio.play()
		$aura.show()
		$get_hurt.set_collision_mask_bit(4, false)
		aura_can_use = false
		$Sprite/aura_timer.start()
		$Sprite/aura_use_again.start()

	movement = move_and_slide(movement.normalized() * speed)
	
	if abs(movement.x) + abs(movement.y) > 1:
		return
	elif get_slide_count() > 0 and Input.is_action_pressed("ui_right"):
		push_right_box()
	elif get_slide_count() > 0 and Input.is_action_pressed("ui_left"):
		push_left_box()
	elif get_slide_count() > 0 and Input.is_action_pressed("ui_up"):
		push_up_box()
	elif get_slide_count() > 0 and Input.is_action_pressed("ui_down"):
		push_down_box()

func push_right_box():
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push_right()

func push_left_box():
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push_left()

func push_up_box():
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push_up()

func push_down_box():
	var box = get_slide_collision(0).collider as Box
	if box:
		box.push_down()
	
func _on_Sprite_animation_finished():
	if $Sprite.animation == "attack":
		$Sprite/attack/CollisionShape2D.disabled = true
		is_attack = false
		$Sprite/attack/CollisionShape2D/hit_sprite.visible = false
	elif $Sprite.animation == "die":
		pass
		
func dash():
	dashing = false
	$dash.play()
	$Sprite.play("Dash")
	speed = 150
	emit_signal("dash_fade")


func _on_dash_timer_timeout():
	is_dash = false
	speed = 50
	dashing = true


func _on_attack_area_entered(area):
	$Sprite/attack/CollisionShape2D/hit_sprite.visible = true
	$Sprite/attack/CollisionShape2D/hit_sprite.play("hit")


func _on_get_hurt_body_entered(body):
	$get_hit.play()
	hp -= 1
	$get_hurt.set_collision_mask_bit(4, false)
	emit_signal("get_hit")
	$cam_move.play("cam_move")
	$hurt_timer.start()
	$hurt_hlsa_2.start()
	if body.is_in_group("darkness"):
		hp = 0
	if hp == 0:
		$get_hit.stop()
		set_collision_layer_bit(2, false)
		$get_hurt.set_collision_mask_bit(4, false)
		$get_hurt/CollisionShape2D.disabled = true
		$player_shape.disabled = true
		emit_signal("die")
		is_die = true
		die()


func die():
	$die_aud.play()
	$die_timer.start()
	$Sprite.play("die")

func _on_hurt_timer_timeout():
	$get_hurt.set_collision_mask_bit(4, true)
	$hurt_hlsa.stop()
	$hurt_hlsa_2.stop()
	$Sprite.visible = true

func _on_hurt_hlsa_timeout():
	$Sprite.visible = false
	$hurt_hlsa_2.start()

func _on_hurt_hlsa_2_timeout():
	$Sprite.visible = true
	$hurt_hlsa.start()


func _on_portal_fadeout():
	$Sprite.hide()
	$get_hurt.set_collision_mask_bit(4, false)

func _on_die_timer_timeout():
	get_tree().reload_current_scene()


func _on_get_hurt_area_entered(area):
	$get_hit.play()
	hp -= 1
	$get_hurt.set_collision_mask_bit(4, false)
	emit_signal("get_hit")
	$cam_move.play("cam_move")
	$hurt_timer.start()
	$hurt_hlsa_2.start()
	if hp == 0:
		set_collision_layer_bit(2, false)
		$get_hurt/CollisionShape2D.disabled = true
		$player_shape.disabled = true
		emit_signal("die")
		is_die = true
		die()

func _on_shot_timer_timeout():
	shot_counter = 5

func _on_hand_timer_timeout():
	$Sprite/hand.hide()


func _on_aura_timer_timeout():
	$aura_audio.stop()
	$aura.hide()
	$get_hurt.set_collision_mask_bit(4, true)


func _on_aura_use_again_timeout():
	aura_can_use = true
