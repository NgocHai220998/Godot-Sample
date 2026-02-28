@tool
class_name TutorialOverlay
extends ColorRect

signal overlay_clicked

@export var padding: float = 4.0:
	set(value):
		padding = value
		if is_inside_tree() and not _target_nodes.is_empty():
			_update_focus_rects()
@export var transition_duration: float = 0.3

var _safe_rects: Array[Rect2] = []
var _target_nodes: Array[Control] = []

var _prev_positions: Array[Vector2] = []
var _prev_sizes: Array[Vector2] = []
var _transition_weight: float = 1.0
var _tween: Tween

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		overlay_clicked.emit()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _target_nodes.is_empty():
		return
		
	_update_focus_rects()

#region Public API
func reset() -> void:
	_target_nodes.clear()
	_safe_rects.clear()
	visible = false

func focus_on_steps(nodes: Array[Control]) -> void:
	if not Engine.is_editor_hint() and visible and not _target_nodes.is_empty():
		_capture_current_state()
		_transition_weight = 0.0
		if _tween and _tween.is_valid():
			_tween.kill()
		_tween = create_tween()
		_tween.tween_property(self , "_transition_weight", 1.0, transition_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	else:
		_transition_weight = 1.0

	_target_nodes = nodes
	visible = true
	_update_focus_rects()
#endregion

#region Core Logic
func _capture_current_state() -> void:
	_prev_positions.clear()
	_prev_sizes.clear()
	
	var overlay_global_rect: Rect2 = get_global_rect()
	for node: Control in _target_nodes:
		if not is_instance_valid(node) or not node.is_visible_in_tree():
			continue
			
		var global_rect: Rect2 = node.get_global_rect()
		var padded_size: Vector2 = global_rect.size + Vector2.ONE * padding * 2.0
		var padded_pos: Vector2 = global_rect.position - Vector2.ONE * padding
		var local_pos: Vector2 = padded_pos - overlay_global_rect.position
		
		_prev_positions.append(local_pos + padded_size * 0.5)
		_prev_sizes.append(padded_size)

func _update_focus_rects() -> void:
	_safe_rects.clear()

	var overlay_global_rect: Rect2 = get_global_rect()
	var current_positions: Array[Vector2] = []
	var current_sizes: Array[Vector2] = []

	for node: Control in _target_nodes:
		if not is_instance_valid(node) or not node.is_visible_in_tree():
			continue

		var global_rect: Rect2 = node.get_global_rect()

		var padded_size: Vector2 = global_rect.size + Vector2.ONE * padding * 2.0
		var padded_pos: Vector2 = global_rect.position - Vector2.ONE * padding

		var local_pos: Vector2 = padded_pos - overlay_global_rect.position
		var rect: Rect2 = Rect2(local_pos, padded_size)

		_safe_rects.append(rect)

		current_positions.append(local_pos + padded_size * 0.5)
		current_sizes.append(padded_size)

	if material is ShaderMaterial:
		var shader_positions: Array[Vector2] = []
		var shader_sizes: Array[Vector2] = []
		
		if _transition_weight < 1.0:
			var max_count: int = max(_prev_positions.size(), current_positions.size())
			for i: int in range(max_count):
				var start_pos: Vector2 = _prev_positions[i] if i < _prev_positions.size() else (current_positions[i] if i < current_positions.size() else Vector2.ZERO)
				var end_pos: Vector2 = current_positions[i] if i < current_positions.size() else start_pos
				
				var start_size: Vector2 = _prev_sizes[i] if i < _prev_sizes.size() else Vector2.ZERO
				var end_size: Vector2 = current_sizes[i] if i < current_sizes.size() else Vector2.ZERO
				
				shader_positions.append(start_pos.lerp(end_pos, _transition_weight))
				shader_sizes.append(start_size.lerp(end_size, _transition_weight))
		else:
			shader_positions = current_positions
			shader_sizes = current_sizes

		material.set_shader_parameter("target_count", shader_positions.size())
		material.set_shader_parameter("target_positions", shader_positions)
		material.set_shader_parameter("target_sizes", shader_sizes)
		material.set_shader_parameter("overlay_size", get_global_rect().size)

func _has_point(point: Vector2) -> bool:
	for rect: Rect2 in _safe_rects:
		if rect.has_point(point):
			return false
	return true
#endregion
