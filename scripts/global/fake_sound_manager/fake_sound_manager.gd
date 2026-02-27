class_name FakeSoundManager
extends RefCounted

enum SoundFX {
	NONE = 0,
	HOVER = 1,
	CLICK = 2,
	SFX_SUCCESS = 3,
	SFX_FAIL = 4,
}

static func play(sound_fx: SoundFX) -> void:
	if sound_fx == SoundFX.NONE: return
	
	print("Playing SFX: ", sound_fx)
