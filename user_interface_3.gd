extends CanvasLayer

onready var hp_bar = $Control/health_bar
var shot_counter = 5

func _ready():
	$fade/fade_anim.play("load_scene")
	$Control.hide()
	hp_bar.value = 10
	$Control/Sprite/pcs.text = "0"

	
func _process(delta):
	$Button.position.x = get_viewport().size.x - 150
	$Control/attack.position.x = get_viewport().size.x -374
	$Control/dash.position.x = get_viewport().size.x - 660
	$Control/TextureProgress.rect_position.x = get_viewport().size.x - 660
	$Control/shot.position.x = get_viewport().size.x - 580
	$Control/shot_fade.rect_position.x = get_viewport().size.x - 580
	$Control/locked/Sprite.position.x = get_viewport().size.x - 180
	if Input.is_action_just_released("dash"):
		$Control/dash.set_process_input(false)
		$Control/dash_blocker.start()
	if Input.is_action_just_released("shot"):
		shot_counter -= 1
	if shot_counter == 0:
		$Control/shot.set_process_input(false)
		$Control/shot_fade/shotfade.play("shotfade")


func _on_dash_blocker_timeout():
	$Control/dash.pressed
	$Control/dash.set_process_input(true)


func _on_player_die(): #player die singal összekapcsolása
	queue_free()
	

func _on_portal_opener_body_entered(body): #portal openert ide kell kapcsolni
	$Control/Sprite/pcs.text = "1"
	$pickup.play()

func _on_portal_fadeout():#portaltól össze kell kötni
	$Control.hide()
	$Button.hide()
	$fade/fade_anim.play("fade")

func _on_fade_anim_animation_finished(anim_name):
	if anim_name == "load_scene":
		$Control.show()
		$Control/attack.show()
		$Control/locked.show()
		$Control/dash.show()
		$Control/shot.show()
		$Button.show()
		
	if anim_name == "fade":
		get_node("/root/SaveSystem").i += 1
		get_tree().change_scene(get_node("/root/SaveSystem").scenes[get_node("/root/SaveSystem").i])
		get_node("/root/SaveSystem").save_data()

func _on_player_dash_fade():
		$Control/TextureProgress/dash_fade.play("dash_fade")


func _on_shotfade_animation_finished(anim_name):
	if anim_name == "shotfade":
		shot_counter = 5
		$Control/shot.pressed
		$Control/shot.set_process_input(true)
		

func _on_Button_pressed():
	$Control.hide()
	$reset_menu.show()
	$Button.hide()


func _on_reset_menu_hide_menu():
	$Control.show()
	$Button.show()
	$reset_menu.hide()
