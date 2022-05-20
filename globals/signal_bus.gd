extends Node

# warning-ignore:unused_signal
signal resource_removed(ref)

# warning-ignore:unused_signal
signal chunk_pressed(cell)
# warning-ignore:unused_signal
signal cell_pressed(cell)
# warning-ignore:unused_signal
signal stockpile_created(stockpile)
# Time updated
signal updated(time_hash)
# item created on world map
signal item_on_world_map(item_pos, item_ref)
# for creating feelings
signal create_feeling(feeling_id)
# object enters a characters zone for triggering personality reactions
signal object_entered_proximity(object)
# character enters a characters zone for triggering personality reactions
signal character_entered_proximity(character)
# modfies a characters need value
signal modify_need(need_id, amount)
