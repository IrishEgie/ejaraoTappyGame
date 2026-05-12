extends Node
@warning_ignore("unused_signal")
# 1. The EVENT: Something happened in the world
signal on_score_generated

# 2. The UPDATE: The data has changed, UI should refresh
signal on_score_updated(new_score: int)

signal on_player_died
signal on_player_hit_ground
signal on_game_over
