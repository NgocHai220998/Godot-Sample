extends CanvasLayer

signal next_step(step: StepID)
signal tutorial_skipped

enum StepID {
	NONE,
	STEP_01,
	STEP_02,
	STEP_03,
	STEP_04,
}

@onready var tutorial_overlay: TutorialOverlay = %Overlay

var _current_step: StepID = StepID.NONE
var _step_ids: Array[StepID]

var _current_index: int = 0

func _ready() -> void:
	visible = false

#region Input & Signal Handlers
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		skip_tutorial()
		get_viewport().set_input_as_handled()
#endregion

#region Public API
func skip_tutorial() -> void:
	_current_step = StepID.NONE
	visible = false
	tutorial_skipped.emit()
func start_tutorial(ids: Array[StepID]) -> void:
	if ids.is_empty(): return
	
	visible = true
	_step_ids = ids
	
	_current_step = _step_ids[0]
	_current_index = 0
	next_step.emit(_current_step)
 
func do_next_step() -> void:
	if _current_index != -1 and _current_index + 1 < _step_ids.size():
		_current_step = _step_ids[_current_index + 1]
		_current_index += 1
		
		await get_tree().create_timer(0.015).timeout
		next_step.emit(_current_step)
	else:
		_current_step = StepID.NONE
		visible = false
#endregion
