@tool
class_name TooltipComponent
extends Control

enum DisplayMode {CLICK_TO_TOGGLE, HOVER_TO_SHOW}

@export var target_node: Control:
	set(value):
		target_node = value
		update_configuration_warnings()

@export var tooltip_content: Control:
	set(value):
		tooltip_content = value
		update_configuration_warnings()

@export_group("Behavior")
@export var display_mode: DisplayMode = DisplayMode.CLICK_TO_TOGGLE
@export var hover_delay: float = 0.2 # Delay before showing tooltip on hover

@export_group("FX")
@export_subgroup("Visual FX")
@export var overshoot_scale: float = 1.015

@export_subgroup("Sound FX")
@export var sfx_open: FakeSoundManager.SoundFX = FakeSoundManager.SoundFX.NONE

@onready var _click_timer: Timer = $ClickTimer

var _is_hovered: bool = false
var _is_open: bool = false
var _tween: Tween

func _ready() -> void:
	if Engine.is_editor_hint():
		_auto_assign_target()
		return
	
	_connect_signals()
	
	visible = false

#region Input Handler
func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if display_mode == DisplayMode.CLICK_TO_TOGGLE and _is_open:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos: Vector2 = get_global_mouse_position()
			var clicked_target: bool = target_node and target_node.get_global_rect().has_point(mouse_pos)
			var clicked_tooltip: bool = tooltip_content and tooltip_content.get_global_rect().has_point(mouse_pos)
			
			if not clicked_target and not clicked_tooltip:
				_close_tooltip()

func _on_target_mouse_entered() -> void:
	if display_mode != DisplayMode.HOVER_TO_SHOW: return
	_is_hovered = true
	_click_timer.start(hover_delay)

func _on_target_mouse_exited() -> void:
	if display_mode != DisplayMode.HOVER_TO_SHOW: return
	_is_hovered = false
	_click_timer.stop()
	if _is_open:
		_close_tooltip()

func _on_target_gui_input(event: InputEvent) -> void:
	if display_mode != DisplayMode.CLICK_TO_TOGGLE: return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_open:
			_close_tooltip()
		else:
			_open_tooltip()
#endregion


#region Core Logic
func _on_click_timer_timeout() -> void:
	if display_mode == DisplayMode.HOVER_TO_SHOW and _is_hovered:
		_open_tooltip()

func _open_tooltip() -> void:
	if _is_open: return
	_is_open = true
	FakeSoundManager.play(sfx_open)
	_play_open_animation()

func _close_tooltip() -> void:
	if not _is_open: return
	_is_open = false
	_click_timer.stop()
	_play_close_animation()
#endregion


#region Animations
func _kill_tween() -> void:
	if _tween and _tween.is_running():
		_tween.kill()

func _create_tween() -> Tween:
	_kill_tween()
	_tween = create_tween()
	return _tween

func _play_open_animation() -> void:
	if not is_inside_tree(): return
	var tween: Tween = _create_tween()
	if not tween: return
	
	scale = Vector2(0.5, 0.5)
	visible = true
	
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self , "scale", Vector2(overshoot_scale, overshoot_scale), 0.1)
	tween.tween_property(self , "scale", Vector2.ONE, 0.15)
	
func _play_close_animation() -> void:
	if not is_inside_tree() or not visible:
		visible = false
		return
		
	var tween: Tween = _create_tween()
	if not tween: return
	
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self , "scale", Vector2(0.5, 0.5), 0.15)
	
	await tween.finished
	visible = false
#endregion

#region Helpers
func _connect_signals() -> void:
	if not target_node: return
	
	if not target_node.mouse_entered.is_connected(_on_target_mouse_entered):
		target_node.mouse_entered.connect(_on_target_mouse_entered)
	
	if not target_node.mouse_exited.is_connected(_on_target_mouse_exited):
		target_node.mouse_exited.connect(_on_target_mouse_exited)
		
	if not target_node.gui_input.is_connected(_on_target_gui_input):
		target_node.gui_input.connect(_on_target_gui_input)
		
	if not _click_timer.timeout.is_connected(_on_click_timer_timeout):
		_click_timer.timeout.connect(_on_click_timer_timeout)

func _auto_assign_target() -> void:
	if target_node == null and get_parent() is Control:
		target_node = get_parent()
		notify_property_list_changed()

func _set_pivot_center() -> void:
	tooltip_content.set_deferred("pivot_offset_ratio", Vector2(0.5, 0.5))

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not Engine.is_editor_hint(): return warnings
	
	if target_node == null:
		warnings.append("Target Node is not assigned. Component won't receive input.")
	if tooltip_content == null:
		warnings.append("Tooltip Content is null. Nothing will be displayed.")
		
	return warnings
#endregion
