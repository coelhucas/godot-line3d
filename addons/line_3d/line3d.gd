tool
extends Spatial
class_name Test3D

var _mi: MeshInstance

export(Material) var material_override setget _set_material
export(NodePath) var origin setget _set_origin
export(NodePath) var target setget _set_target
export(float) var thickness = 1 setget _set_thickness

var _target: Spatial
var _origin: Spatial

var _target_position: Vector3


func _enter_tree():
	_setup_mi()

func _setup_mi() -> void:
	if not get_node_or_null("MeshInstance"):
		_mi = MeshInstance.new()
		_mi.mesh = CylinderMesh.new()
		_mi.mesh.radial_segments = 4
		_mi.mesh.top_radius = thickness
		_mi.global_transform = global_transform
		_mi.mesh.bottom_radius = thickness
		_mi.rotation_degrees = Vector3(0, -90, -90)
		_mi.name = "MeshInstance"
		add_child(_mi)
		print(_mi.name)

func _ready() -> void:
	_target = get_node(target)
	_origin = get_node(origin)
	
	if material_override:
		_mi.material_override = material_override


func _process(_delta: float) -> void:
	if not _target or not _origin: return
	
	if not _mi:
		_setup_mi()
		return
		
	
	if global_transform.origin != _origin.global_transform.origin:
		global_transform.origin = _origin.global_transform.origin
		_update_mesh()
		
	self.look_at(_target.global_transform.origin, Vector3.UP)

	if _target.global_transform.origin != _target_position:
		_update_mesh()


func _update_mesh() -> void:
	self._mi.mesh.height = global_transform.origin.distance_to(_target.global_transform.origin)
	self._mi.transform.origin.z = -_mi.mesh.height/2
	self._target_position = _target.global_transform.origin


func _set_target(_t):
	_target = get_node(_t)
	target = _t


func _set_origin(_o):
	origin = _o
	var _node = get_node_or_null(_o)
	
	if _node:
		_origin = _node
		global_transform.origin = _origin.global_transform.origin


func _set_thickness(_t):
	_mi = get_node("MeshInstance")

	_mi.mesh.top_radius = _t / 10.0
	_mi.mesh.bottom_radius = _t / 10.0
	
	thickness = _t


func _set_material(_m):
	material_override = _m
	get_node("MeshInstance").material_override = _m
