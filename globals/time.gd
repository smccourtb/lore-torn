extends Node



# Used to define time segments in methods
const MINUTE = 0
const HOUR = 1
const DAY = 2
const MONTH = 3
const YEAR = 4
const ALL = 5 # Used to determine the maximum value

# Used to specify which segments are desired when retreiving the variable
# ie to limit the value to only minutes and hours for the time of day.
const MINUTE_MASK = 1 << MINUTE
const HOUR_MASK = 1 << HOUR
const DAY_MASK = 1 << DAY
const MONTH_MASK = 1 << MONTH
const YEAR_MASK = 1 << YEAR
const ALL_MASK = (YEAR_MASK << 1) - 1
const TIME_MASK = (HOUR_MASK << 1) - 1

const TIME_MULTIPLIERS = {
	"minute" : 1,
	"hour" : 60,
	"day" : 60 * 24,
	"month" : 60 * 24 * 28,
	"year" : 60 * 24 * 28 * 4,
}

#var time_scale = TIME_MULTIPLIERS["month"] / 60.0 # 1 irl min == TIME_MULTIPLIERS["segment of time"]
#var time_scale = TIME_MULTIPLIERS["hour"] / 60.0 # 1 irl sec == TIME_MULTIPLIERS["segment of time"]
var time_scale = TIME_MULTIPLIERS["hour"] / 30.0 # 1 irl sec == TIME_MULTIPLIERS["segment of time"]
var value = 0 # stores the actual time, represents minutes in game
var tick = 0 # time delta, will roll over into minutes

func _init(start_time := {}):
	set_time(start_time)

# Called to advance time. Mostly used to tick the active time but
# can advance any time system if minutes are passed in.
func advance(delta):
	# Adjusts real world seconds to in-game time
	tick += delta * time_scale
	# Store current value to know if a full minute has passed
	var prev_value = value
	# Cast int to only get the minute value
	value += int(tick)
	tick -= int(tick)
	if value != prev_value:
		SignalBus.emit_signal("updated", value)

# Accepts dictionary values to set the time values. This will only adjust time
# for which values are passed in. Will need modifying if this behavior is desired.
func set_time(time_modification : Dictionary):
	for i in ALL:
		var key = TIME_MULTIPLIERS.keys()[i]
		if time_modification.has(key):
			# Set the current value for this segment to 0
			value -= get_segment_value(i) * TIME_MULTIPLIERS[key]
			# Then add the value we want so that it gets set
			value += time_modification[key] * TIME_MULTIPLIERS[key]
	SignalBus.emit_signal("updated", value)

# Returns the value of a section of time (ie year, month, day)
func get_segment_value(value_id : int) -> int:
	var time_value = value
	# Modulate the value to remove all data greater than this segment
	if value_id < ALL - 1:
		time_value %= TIME_MULTIPLIERS.values()[value_id + 1]
	# Divide the value to remove all data less than this segment
	if value_id > 0:
		time_value = int(time_value / TIME_MULTIPLIERS.values()[value_id])
	return time_value

# Returns the value property but only including the masked values
func get_value_from_mask(mask := ALL_MASK):
	var time_value = 0
	for i in ALL:
		# Binary AND the mask with a bit shifted the number of iterations
		# This is true if we're masking for the current segment
		if mask & (1 << i):
			time_value += get_segment_value(i) * TIME_MULTIPLIERS.values()[i]
	return time_value


# warning-ignore:unused_argument
func get_date_as_text(time = self.time) -> String:
	return ""

# Returns a dictionary containing the time values for easier readability
# You can pass this dictionary back into `set_time()` to apply modifications
func get_time_as_dictionary() -> Dictionary:
	var time = {}
	for i in ALL:
		var key = TIME_MULTIPLIERS.keys()[i]
		time[key] = get_segment_value(i)
	return time

# Returns the time formated into a string. Only supports 12 hour format currently
# But can easily be modified for both.
func get_time_as_text(will_floor_minutes = false, \
		will_placeholder_hour = false) -> String:
	var time = get_time_as_dictionary()
	var meridian = "AM" if time.hour < 12 else "PM"
	
	var hour = int(time.hour) % 12
	if hour == 0:
		hour = 12
	if will_placeholder_hour:
		hour = "%02d" % hour
	
	var minute = time.minute
	if will_floor_minutes:
		minute = int(minute / 10) * 10
	minute = "%02d" % minute
	
	return "%s:%s %s" % [hour, minute, meridian]

# Returns a value from 0 to 1 of time clamped between the min and max time
static func clamp(min_time, max_time, time, mask = ALL_MASK):
	var min_value = min_time.get_value_from_mask(mask)
	var max_value = max_time.get_value_from_mask(mask)
	var current_value = clamp(time.get_value_from_mask(mask), \
			min_value, max_value)
	return (current_value - min_value) / float(max_value - min_value)
