@abstract
class_name Attack
extends Node2D

signal attack_finished


@export var shake_amount := .8
@abstract func attack(speed := 1.) -> void
