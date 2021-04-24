class_name AnimationRandomizer
extends Reference

# you have to set the sprite before trying to call play_random_animation

# Also probably a good idea to make the spriteframes local to scene so setting the
# frame doesn't bork other instances.
# I'm not sure this ^ is true, seems like it should only be necessary
#   if you are actually messing with the SpriteFrames resource.

var sprite : AnimatedSprite

# random horizontal and vertical flipping
export(bool) var randomly_flip_h = false
export(bool) var randomly_flip_v = false

export(bool) var debug = false

func _ready():
	if debug:
		print("animation randomizer using sprite: %s" % str(sprite))

func play_random_animation():
	if not sprite:
		print("animation randomizer: no sprite!")
		return
	if not sprite.frames:
		print("animation randomizer: no sprite frames!")
		return
	
	var names = sprite.frames.get_animation_names()
	if names.size() <= 0:
		print("animation randomizer: %s animations to pick from" % str(names.size()))
		return
	
	var anim_name = names[randi() % names.size()]
	
	if debug:
		print("playing anim %s on sprite %s" % [anim_name, str(sprite)])
	
	sprite.play(anim_name)
	# AnimatedSprite doesn't reset the frame when you call play with the same
	# animation it's currently playing
	sprite.frame = 0
	
	if randomly_flip_h:
		if randf() < 0.5:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	
	if randomly_flip_v:
		if randf() < 0.5:
			sprite.flip_v = false
		else:
			sprite.flip_v = true

