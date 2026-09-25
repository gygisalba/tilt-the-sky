extends RefCounted
class_name ResourceUpdate

var PreviousValue : float
var CurrentValue : float
var MaxValue : float

var ResourcePercentage: float:
	get:
		if MaxValue <= 0:
			return 0.0
		return clampf(CurrentValue / MaxValue, 0.0, 1.0)

var IsIncrease: bool:
	get:
		return CurrentValue > PreviousValue

var Delta: float:
	get:
		return CurrentValue - PreviousValue

var AbsoluteDelta: float:
	get:
		return abs(Delta)
