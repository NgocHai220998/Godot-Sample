@tool
class_name StepComponent
extends Control

enum AdvanceMode {REQUIRE_TARGET_CLICK, CLICK_ANYWHERE}

@export var step_id: TutorialManager.StepID = TutorialManager.StepID.NONE:
	set(value):
		step_id = value
		update_configuration_warnings()

@export var target_nodes: Array[Control]:
	set(value):
		target_nodes = value
		update_configuration_warnings()

@export var target_clickable: ClickableComponent:
	set(value):
		target_clickable = value
		update_configuration_warnings()

@export var advance_mode: AdvanceMode = AdvanceMode.REQUIRE_TARGET_CLICK:
	set(value):
		advance_mode = value
		update_configuration_warnings()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	visible = false
	_connect_signals()

#region Input & Signal Handlers
func _on_next_step(id: TutorialManager.StepID) -> void:
	if step_id != id: return
	
	visible = true
	if TutorialManager.tutorial_overlay:
		TutorialManager.tutorial_overlay.focus_on_steps(target_nodes)

func _on_clicked() -> void:
	if not visible: return
	visible = false
	TutorialManager.do_next_step()

func _on_overlay_clicked() -> void:
	if not visible or advance_mode != AdvanceMode.CLICK_ANYWHERE: return
	_on_clicked()
#endregion

#region Helpers
func _connect_signals() -> void:
	if not TutorialManager.next_step.is_connected(_on_next_step):
		TutorialManager.next_step.connect(_on_next_step)
		
	if target_clickable and not target_clickable.clicked.is_connected(_on_clicked):
		target_clickable.clicked.connect(_on_clicked)

	if TutorialManager.tutorial_overlay and not TutorialManager.tutorial_overlay.overlay_clicked.is_connected(_on_overlay_clicked):
		TutorialManager.tutorial_overlay.overlay_clicked.connect(_on_overlay_clicked)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not Engine.is_editor_hint(): return warnings
	
	if step_id == TutorialManager.StepID.NONE:
		warnings.append("Step ID is set to NONE. This component will never activate.")
	
	if target_nodes.is_empty():
		warnings.append("Target Nodes array is empty. The tutorial overlay won't highlight anything.")
		
	if advance_mode == AdvanceMode.REQUIRE_TARGET_CLICK and not target_clickable:
		warnings.append("Target Clickable is not assigned. User cannot progress in REQUIRE_TARGET_CLICK mode.")
		
	return warnings
#endregion
