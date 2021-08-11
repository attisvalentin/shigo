extends KinematicBody2D

var target = null
var move = Vector2()
var hp = 30
var move_speed = 30
var player_in = false
var player_can_hurt = false
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
	if hp == 2:
		$hp_bar.hide()
		$AnimatedSprite/attack.set_collision_layer_bit(4, false)
		$AnimatedSprite/attack/CollisionShape2D.disabled = true
		$AnimatedSprite/get_hurt.set_collision_layer_bit(6, false)
		$AnimatedSprite/get_hurt/CollisionShape2D.disabled = true
		$player_detector.set_collision_mask_bit(1, false)
		$play_attack/CollisionShape2D.disabled = true
		$play_attack.set_collision_mask_bit(1, false)
		$play_attack/CollisionShape2D.disabled = true
		$down_hurt.set_collision_layer_bit(4, false)
		$down_hurt/CollisionShape2D.disabled = true
		emit_signal("dead")
		target = null
		move_speed = 0
		$AnimationPlayer.stop()
		$AnimatedSprite.play("die")
	elif player_in != false and player_can_hurt == false:
		$AnimationPlayer.play("moving")
	elif player_in == false and player_can_hurt == false:
		$AnimationPlayer.play("idle")
	elif player_in == false and player_can_hurt == true:
		$AnimationPlayer.play("attack")
	if move.x < 0:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1


func _on_player_detector_body_entered(body):
	target = body

func _on_player_detector_body_exited(body):
	target = null

func _on_get_hurt_area_entered(area):
	hp -= 1
	$hp_bar.value -= 1
	if hp == 2:
		get_node("/root/Sounds/kio_die").play()

func _on_wait_after_attack_timeout():
	$player_detector.set_collision_mask_bit(1, true)

func _on_play_attack_body_entered(body):
	$player_detector.set_collision_mask_bit(1, false)
	$wait_to_attack.start()
	
func _on_wait_to_attack_timeout():
	player_can_hurt = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		if player_can_hurt == true:
			$wait_to_attack.start()
		
func _on_play_attack_body_exited(body):
	$wait_to_attack.stop()
	$player_go_out.start()
	


func _on_player_go_out_timeout():
	player_can_hurt = false
	$player_detector.set_collision_mask_bit(1, true)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "die":
		emit_signal("end")
		queue_free()
