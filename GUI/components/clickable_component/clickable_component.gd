@tool
class_name ClickableComponent
extends Node

signal clicked

@export var target_node: Control:
	set(value):
		target_node = value
		update_configuration_warnings()

@export var handler_node: Node:
	set(value):
		handler_node = value
		update_configuration_warnings()

@export var method_name: String: # Name of the function that will be called on the Handler Node when clicked.
	set(value):
		method_name = value
		update_configuration_warnings()

@export_group("State")
@export var disabled: bool = false:
	set(value):
		disabled = value
		_update_visual_state()
@export var disabled_modulate: Color = Color(0.6, 0.6, 0.6, 1.0)
@export var click_cooldown: float = 0.15

@export_group("Loading")
@export var loading_enabled: bool = false
@export var loading_icon: Control
@export var nodes_to_hide_on_loading: Array[Control]


@export_group("FX")
@export_subgroup("Visual FX")
@export var glow_color: Color = Color(1.2, 1.2, 1.2, 1.0)
@export var hover_scale_rate: float = 1.015
@export var click_scale_rate: float = 1.15
@export var hover_scale_duration: float = 0.1
@export var click_scale_duration: float = 0.05

@export_subgroup("Sound FX")
@export var sfx_hover: FakeSoundManager.SoundFX = FakeSoundManager.SoundFX.NONE
@export var sfx_click: FakeSoundManager.SoundFX = FakeSoundManager.SoundFX.NONE
@export var sfx_success: FakeSoundManager.SoundFX = FakeSoundManager.SoundFX.NONE
@export var sfx_fail: FakeSoundManager.SoundFX = FakeSoundManager.SoundFX.NONE


var _loading: bool = false
var _click_locked: bool = false # FEATURE: Khóa click tạm thời
var _tween: Tween

func _ready() -> void:
	if Engine.is_editor_hint():
		_auto_assign_target()
		return
	
	_connect_signals()
	_set_pivot_center()
	_set_cursor()
	_update_visual_state()
	_show_loading(false)

#region Input Handler
func _on_click(event: InputEvent) -> void:
	if _loading or disabled or _click_locked: return
	if not _is_press_event(event): return
	
	# Lock click if cooldown is set
	if click_cooldown > 0:
		_click_locked = true
		get_tree().create_timer(click_cooldown).timeout.connect(_unlock_click)
	
	_play_click_pop()
	
	if handler_node and handler_node.has_method(method_name):
		FakeSoundManager.play(sfx_click)
		
		
		if loading_enabled:
			_show_loading(true)
			handler_node.call(method_name, Callable(self , "_on_action_done"))
		else:
			clicked.emit()
			handler_node.call(method_name)

func _on_hover_entered() -> void:
	if _loading or disabled: return
	
	FakeSoundManager.play(sfx_hover)
	_play_hover(true)

func _on_hover_exited() -> void:
	if _loading or disabled: return
	
	_play_hover(false)

func _unlock_click() -> void:
	_click_locked = false
#endregion

#region Callback Handler
func _on_action_done(success: bool = true) -> void:
	_show_loading(false)
	clicked.emit()
	
	if success:
		FakeSoundManager.play(sfx_success)
	else:
		FakeSoundManager.play(sfx_fail)
#endregion

#region Animated
func _kill_tween() -> void:
	if _tween and _tween.is_running():
		_tween.kill()

func _create_tween() -> Tween:
	_kill_tween()
	_tween = create_tween()
	return _tween

func _play_click_pop() -> void:
	if not is_inside_tree(): return
	var tween: Tween = _create_tween()
	if not tween: return
	
	tween.tween_property(target_node, "scale",
		Vector2(click_scale_rate, click_scale_rate), click_scale_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(target_node, "scale",
		Vector2.ONE, click_scale_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _play_hover(enter: bool) -> void:
	if not is_inside_tree(): return
	var tween: Tween = _create_tween()
	if not tween: return
	
	var target_scale: Vector2 = Vector2(hover_scale_rate, hover_scale_rate) if enter else Vector2.ONE
	var target_color: Color = glow_color if enter else Color.WHITE

	tween.tween_property(target_node, "scale", target_scale, hover_scale_duration) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(target_node, "modulate", target_color, hover_scale_duration) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_QUAD)

func _is_press_event(event: InputEvent) -> bool:
	return (
		(event is InputEventMouseButton and event.pressed) or
		(event is InputEventScreenTouch and event.pressed)
	)

func _update_visual_state() -> void:
	if not is_node_ready(): await ready
	
	target_node.modulate = disabled_modulate if disabled else Color.WHITE
#endregion

func _connect_signals() -> void:
	if not target_node.mouse_entered.is_connected(_on_hover_entered):
		target_node.mouse_entered.connect(_on_hover_entered)
	if not target_node.mouse_exited.is_connected(_on_hover_exited):
		target_node.mouse_exited.connect(_on_hover_exited)
	if not target_node.gui_input.is_connected(_on_click):
		target_node.gui_input.connect(_on_click)

func _set_pivot_center() -> void:
	target_node.set_deferred("pivot_offset_ratio", Vector2(0.5, 0.5))

func _set_cursor() -> void:
	target_node.mouse_filter = Control.MOUSE_FILTER_PASS
	target_node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _auto_assign_target() -> void:
	if target_node == null and get_parent():
		target_node = get_parent()
		notify_property_list_changed()

func _show_loading(show: bool) -> void:
	_loading = show
	if loading_icon: loading_icon.visible = show
	
	for node_to_hide_on_loading: Control in nodes_to_hide_on_loading:
		node_to_hide_on_loading.visible = !show

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not Engine.is_editor_hint(): return warnings
	
	if handler_node == null:
		warnings.append("Handler Node is not assigned. Click events will not be processed.")
	if target_node == null:
		warnings.append("Target Node is not assigned. This component will not receive click input.")
	if method_name.strip_edges().is_empty():
		warnings.append("Method name is empty. Please specify a function to call on click.")
	elif handler_node != null and not handler_node.has_method(method_name):
		warnings.append(
			"Handler Node does not implement method '%s'." % method_name
		)
	
	return warnings
