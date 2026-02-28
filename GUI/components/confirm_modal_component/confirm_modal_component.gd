class_name ConfirmModalComponent
extends CanvasLayer

signal confirmed(result: bool)

@onready var _header_label: Label = %HeaderLabel
@onready var _description_label: Label = %DescriptionLabel
@onready var _cancel_label: Label = %CancelLabel
@onready var _ok_label: Label = %OkLabel

@onready var _overlay: ColorRect = %Overlay
@onready var _panel: ColorRect = %Panel

var _cancel_on_overlay_click: bool = false
const SCENE_PATH: String = "res://GUI/components/confirm_modal_component/confirm_modal_component.tscn"

func _ready() -> void:
	_overlay.gui_input.connect(_on_overlay_gui_input)
	
	_set_pivot_center()
	_play_intro_animation()

static func release(parent: Node, custom_data: Dictionary = {}) -> ConfirmModalComponent:
	var component: ConfirmModalComponent = _create_component()
	parent.add_child(component)
	component.load_ui(custom_data)
	
	return component

static func _create_component() -> ConfirmModalComponent:
	var packed_scene: PackedScene = load(SCENE_PATH)
	return packed_scene.instantiate()

func load_ui(data: Dictionary = {}) -> void:
	if not is_node_ready(): await ready
	
	_header_label.text = data.get("header", "Confirmation Modal")
	_description_label.text = data.get("description", "Are you sure you want to proceed?")
	_cancel_label.text = data.get("cancel", "Cancel")
	_ok_label.text = data.get("ok", "Confirm")
	_cancel_on_overlay_click = data.get("cancel_on_overlay_click", _cancel_on_overlay_click)

#region Animations & Helpers
func _play_intro_animation() -> void:
	if not is_inside_tree(): return
	var tween: Tween = create_tween()
	if not tween: return
	
	_overlay.modulate.a = 0.0
	_panel.scale = Vector2(0.8, 0.8)
	_panel.modulate.a = 0.0
	
	tween.set_parallel(true)
	tween.tween_property(_overlay, "modulate:a", 1.0, 0.2)
	tween.tween_property(_panel, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(_panel, "modulate:a", 1.0, 0.15)

func _play_outro_animation() -> void:
	if not is_inside_tree(): return
	var tween: Tween = create_tween()
	if not tween: return
	
	tween.set_parallel(true)
	tween.tween_property(_overlay, "modulate:a", 0.0, 0.15)
	tween.tween_property(_panel, "scale", Vector2(0.8, 0.8), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(_panel, "modulate:a", 0.0, 0.15)
	
	await tween.finished

func _is_click_event(event: InputEvent) -> bool:
	return (
		(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or
		(event is InputEventScreenTouch and event.pressed)
	)
#endregion

func _set_pivot_center() -> void:
	_panel.set_deferred("pivot_offset_ratio", Vector2(0.5, 0.5))

func _on_overlay_gui_input(event: InputEvent) -> void:
	if _cancel_on_overlay_click and _is_click_event(event):
		_on_cancel_clicked()

func _on_cancel_clicked() -> void:
	confirmed.emit(false)
	_finish()

func _on_ok_clicked() -> void:
	confirmed.emit(true)
	_finish()

func _finish() -> void:
	await _play_outro_animation()
	call_deferred("queue_free")
