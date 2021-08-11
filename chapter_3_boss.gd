extends Node2D



func _ready():
	if get_node("/root/Sounds/boss_fight_1").playing == true:
		return
	else:
		get_node("/root/Sounds/boss_fight_1").play()
#	get_viewport_rect().size.x
#	get_viewport_rect().size.y
	$portal.visible = false
	$ColorRect.visible = false

func _on_portal_opener_body_entered(body): # portál nyitó összekapcsolása
	if body.name == "player":
		$portal.visible = true
		$portal_opener.queue_free()

func _on_player_get_hit(): #player get_hit signal összekapcsolása
	$user_interface.hp_bar.value -= 1
	
func _on_cam_change_cam_change():
	$user_interface/Control.hide()#csak ha a kapu máshol van, akkor kell

func _on_gate_cam_back():
	$user_interface/Control.show()#csak ha a kapu máshol van, akkor kell

func _on_gate4_cam_back():
	$user_interface/Control.show()#csak ha a kapu máshol van, akkor kell

func _on_valley_body_entered(body):
	if body.name == "player":
		body.hide()
		$user_interface/Control.hide()
		$user_interface/Button.hide()
		$reset.start()
		$AnimationPlayer.play("fall")


func _on_reset_timeout():
	get_tree().reload_current_scene()



func _on_speaker_body_entered(body):
	if body.name == "player":
		$user_interface/Control.hide()
		$user_interface/text_control2.show()


func _on_text_control2_hide_speaker():
	$YSort/speaker.queue_free()


func _on_text_control2_hide_text():
	$user_interface/text_control2.hide()


func _on_text_control2_show_control():
	$user_interface/Control.show()

func _on_kokeh_die():
	get_node("/root/Sounds/boss_fight_1").stop()
	$user_interface/Control.hide()
	$user_interface/Button.hide()

func _on_kokeh_meghalt():
	$user_interface/Control.show()
	$user_interface/Button.show()

