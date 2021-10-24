# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name globalTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://globals/global.gd'

func test_resource_nodes_is_dict() -> void:
	assert_dict(Global.get_resource_nodes("tree")).is_true()
