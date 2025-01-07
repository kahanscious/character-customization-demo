extends Control

@onready
var viewport: SubViewport = $HSplitContainer/CharacterPreviewPanel/MarginContainer/VBoxContainer/SubViewportContainer/SubViewport
@onready
var viewport_container: SubViewportContainer = $HSplitContainer/CharacterPreviewPanel/MarginContainer/VBoxContainer/SubViewportContainer
@onready
var character: Character = $HSplitContainer/CharacterPreviewPanel/MarginContainer/VBoxContainer/SubViewportContainer/SubViewport/Character


func _ready() -> void:
	character.set_as_preview()

	call_deferred("_center_character")

	viewport_container.resized.connect(_on_viewport_resized)


func _center_character() -> void:
	character.position = Vector2(viewport.size.x / 2, viewport.size.y / 2)


func _on_viewport_resized() -> void:
	var container_size = viewport_container.size
	var min_size = min(container_size.x, container_size.y)

	viewport.size = Vector2i(min_size, min_size)

	_center_character()
