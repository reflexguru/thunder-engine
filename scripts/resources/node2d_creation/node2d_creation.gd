# Create a Node2D with physics and some other parameters
extends Resource
class_name Node2DCreation

@export_category("Node2DCreation")
@export_group("Creation","creation_")
@export var creation_node: PackedScene
@export var creation_offset: Vector2
@export_node_path(Node2D) var creation_attachment: NodePath
@export var creation_z_index: int
@export var creation_z_as_relative: bool = true
@export var creation_y_sort_enabled: bool
@export var creation_physics: GravityBody2DPhysics
@export_group("Inheritance","inherit_")
@export var inherit_rotation: bool
@export var inherit_scale: bool
@export var inherit_skew: bool

var node: Node2D
var base: Node2D
var attachment: Node2D


func prepare(on: Node2D) -> void:
	base = on
	
	if !base:
		printerr("[Null Base Node Error] You set a null as a base node! Please check the parameter you input!")
		_report_resource()
		return
	
	if !node:
		printerr("[Node2D Preparing Error] No creations installed! Please check \"creation_node\" first!")
		_report_resource()
		return
	
	node = creation_node.instantiate()
	
	attachment = base.get_node_or_null(creation_attachment)
	
	if !attachment: return
	
	node.add_child(attachment.duplicate())


func create(as_child: bool = false) -> void:
	if !base:
		printerr("[Null Base Error] Created on Nil! Please check \"base\" first!")
		_report_resource()
		return
	
	if !node:
		printerr("[Node2D Null Error] Created Nil! Please check \"node\" first!")
		_report_resource()
		return
	
	if as_child:
		base.add_child(node)
	else:
		base.add_sibling(node)
	
	node.translate(creation_offset)
	node.z_index = creation_z_index
	node.z_as_relative = creation_z_as_relative
	node.y_sort_enabled = creation_y_sort_enabled
	
	if inherit_rotation:
		node.rotation = base.rotation
	if inherit_scale:
		node.scale = base.scale
	if inherit_skew:
		node.skew = base.skew


func call_physics() -> GravityBody2DPhysics:
	if node is GravityBody2D:
		return creation_physics.bind(node)
	else:
		return null


func _report_resource() -> void:
	printerr("[Report] The error happened on: " + str(get_rid()) + ", with path:" + resource_path)
