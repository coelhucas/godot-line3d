tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Line3D", "Spatial", preload("line3d.gd"), preload("line3d.svg"))
	pass


func _exit_tree():
	remove_custom_type("Line3D")
