extends Node2D

var i = 0
var scenes = ["res://scenes/intros/intro_1.tscn", 
	"res://scenes/intros/intro_2.tscn",
	"res://scenes/intros/intro_3.tscn",
	"res://scenes/intros/intro_4.tscn",
	"res://scenes/intros/intro_5.tscn",
	"res://scenes/chapters/chapter_one.tscn",
	"res://scenes/chapters/chapter_1_lvl_1.tscn",
	"res://scenes/chapters/chapter_1_lvl_2.tscn",
	"res://scenes/chapters/chapter_1_lvl_3.tscn",
	"res://scenes/chapters/chapter_1_lvl_4.tscn",
	"res://scenes/chapters/chapter_1_movie_1.tscn",
	"res://scenes/chapters/chapter_1_lvl_5.tscn",
	"res://scenes/chapters/chapter_1_lvl_6.tscn",
	"res://scenes/chapters/chapter_1_lvl_7_pre.tscn",
	"res://scenes/chapters/chapter_1_lvl_7.tscn",
	"res://scenes/chapters/chapter_1_lvl_8.tscn",
	"res://scenes/chapters/chapter_1_kio_pre.tscn",
	"res://scenes/chapters/chapter_1_boss_kio.tscn",
	"res://scenes/chapters/chapter_1_lvl_10.tscn",
	"res://scenes/chapters/chapter_two.tscn",
	"res://scenes/chapters/chapter_2_lvl_1.tscn",
	"res://scenes/chapters/chapter_2_lvl_2.tscn",
	"res://scenes/chapters/chapter_2_lvl_3.tscn",
	"res://scenes/chapters/chapter_2_lvl_4.tscn",
	"res://scenes/chapters/chapter_2_lvl_5.tscn",
	"res://scenes/chapters/chapter_2_lvl_6.tscn",
	"res://scenes/chapters/chapter_2_lvl_7.tscn",
	"res://scenes/chapters/chapter_2_preboss.tscn",
	"res://scenes/chapters/chapter_2_boss_rysin.tscn",
	"res://scenes/chapters/chapter_three.tscn",
	"res://scenes/chapters/chapter_3_lvl_1.tscn",
	"res://scenes/chapters/chapter_3_lvl_2.tscn",
	"res://scenes/chapters/chapter_3_lvl_3.tscn",
	"res://scenes/chapters/chapter_3_lvl_4.tscn",
	"res://scenes/chapters/chapter_3_lvl_5.tscn",
	"res://scenes/chapters/chapter_3_lvl_6.tscn",
	"res://scenes/chapters/chapter_3_preboss.tscn",
	"res://scenes/chapters/chapter_3_boss.tscn",
	"res://scenes/chapters/chapter_four.tscn",
	"res://scenes/chapters/chapter_4_final_boss_pre.tscn",
	"res://scenes/chapters/chapter_4_final_boss.tscn",
	"res://scenes/chapters/outro.tscn"]

var save_path = "user://saveFile.save"

func _ready():
	pass
	
func save_data():
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_var(i)
	file.close()
	print(File.WRITE)

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			i = file.get_var()
	else:
		i = 0
	file.close()
