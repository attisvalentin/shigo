extends YSort

signal open
signal kokeh_ded
func _ready():
	$gate.hide()
	$gate.set_collision_layer_bit(0, false)

func _on_gate_closer_1_body_entered(body):
	$gate.show()
	$gate.set_collision_layer_bit(0, true)
	$gate_closer_1.queue_free()


func _on_gate_1_open_body_exited(body):
	$gate2/dust.visible = true
	$gate2/dust.play("dust")
	$gate2/gate_anim.play("open")


func _on_bridge_open_body_exited(body):
	emit_signal("open")


func _on_gate_2_open_body_exited(body):
	emit_signal("kokeh_ded")
	$gate3/dust.visible = true
	$gate3/dust.play("dust")
	$gate3/gate_anim.play("open")
