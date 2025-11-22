extends Node2D

@export var musicLoops: Dictionary[String, AudioStream]
@export var streamClips: Dictionary[String, AudioStream]
@onready var musicPlayer: AudioStreamPlayer = $MusicStreamPlayer
@onready var sfxPlayer: AudioStreamPlayer = $SFXStreamPlayer

func _play_sound(clipName: String):
	if streamClips.has(clipName):
		sfxPlayer.stream = streamClips[clipName]
		sfxPlayer.play()

func _switch_music(loopName: String):
	if musicLoops.has(loopName):
		musicPlayer.stream = musicLoops[loopName]
		musicPlayer.play()
		musicPlayer.stream_paused = false
func pause_music():
	musicPlayer.stream_paused = true
func resume_music():
	musicPlayer.stream_paused = false

func _stop_music():
	musicPlayer.stop()


func _on_music_stream_player_finished() -> void:
	musicPlayer.play() # Looping idk
