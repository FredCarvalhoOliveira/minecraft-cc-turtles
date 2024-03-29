from typing import Optional

from cc import turtle as cc_turtle

LENGTH = 16
WIDTH = 5
DEPTH = 8
DOWN_ON_START = 91
MINERAL = 'diamond'


class CircularList(list):
	def __getitem__(self, index):
		return super(CircularList, self).__getitem__(index % len(self))


class SmartTurtle:
	def __init__(self):
		self.__compass  = CircularList(['N', 'E', 'S', 'O'])
		self.__turtle   = cc_turtle
		self.__x_offset: int = 0
		self.__y_offset: int = 0
		self.__z_offset: int = 0
		self.__curr_orient_idx: int = 0
		self.__origin_abs_y: Optional[int] = None


	@property
	def orientation(self):
		return self.__compass[self.__curr_orient_idx]

	@property
	def manhattan_dist_origin(self):
		return abs(self.__x_offset) + abs(self.__y_offset) + abs(self.__z_offset)

	@property
	def inventory(self):
		inventory = {}
		for i in range(1, 17):
			self.__turtle.select(i)
			item_detail = self.__turtle.getItemDetail()
			inventory[i] = item_detail
		return inventory

	def dig(self):
		try:
			return self.__turtle.dig()
		except:
			return False

	def dig_up(self):
		try:
			return self.__turtle.digUp()
		except:
			return False

	def dig_down(self):
		try:
			return self.__turtle.digDown()
		except:
			return False

	def turn_right(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.turnRight()
			self.__curr_orient_idx += 1

	def turn_left(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.turnLeft()
			self.__curr_orient_idx -= 1

	def forward(self, num_steps: int = 1):
		success = True

		for i in range(num_steps):
			step_success = self.__turtle.forward()
			if step_success:
				if self.orientation == 'N':
					self.__x_offset += 1
				elif self.orientation == 'S':
					self.__x_offset -= 1
				elif self.orientation == 'E':
					self.__z_offset += 1
				elif self.orientation == 'O':
					self.__z_offset -= 1
			success = success and step_success
		return success

	def back(self, num_steps: int = 1):
		for i in range(num_steps):
			op_success = self.__turtle.back()
			if op_success:
				if self.orientation == 'N':
					self.__x_offset -= 1
				elif self.orientation == 'S':
					self.__x_offset += 1
				elif self.orientation == 'E':
					self.__z_offset -= 1
				elif self.orientation == 'O':
					self.__z_offset += 1
			else:
				return False
		return True

	def up(self, num_steps: int = 1):
		for i in range(num_steps):
			op_success = self.__turtle.up()
			if op_success:
				self.__y_offset += 1
			else:
				return False
		return True

	def down(self, num_steps: int = 1):
		for i in range(num_steps):
			op_success = self.__turtle.down()
			if op_success:
				self.__y_offset -= 1
			else:
				return False
		return True

	def dig_go_forward(self, num_steps: int = 1):
		for i in range(num_steps):
			self.dig()
			op_success = self.forward()
			if not op_success:
				return False
		return True

	def dig_go_up(self, num_steps: int = 1):
		for i in range(num_steps):
			self.dig_up()
			op_success = self.up()
			if not op_success:
				return False
		return True

	def dig_go_down(self, num_steps: int = 1):
		for i in range(num_steps):
			self.dig_down()
			op_success = self.down()
			if not op_success:
				return False
		return True



	def sanitize_inventory(self):
		black_list = ['minecraft:cobblestone',
					  'minecraft:dirt',
					  'minecraft:gravel',
					  'minecraft:sand',
					  'minecraft:andesite',
					  'minecraft:granite',
					  'minecraft:cobbled_deepslate',
					  'minecraft:tuff',
					  'minecraft:calcite',
					  'minecraft:diorite',
					  'create:limestone']
		# white_list = ['minecraft:coal',
		# 			  'minecraft:raw_copper',
		# 			  'minecraft:raw_iron',
		# 			  'minecraft:raw_gold',
		# 			  'minecraft:diamond',
		# 			  'minecraft:emerald',
		# 			  'minecraft:redstone',
		# 			  'minecraft:lapis_lazuli',
		# 			  'minecraft:lapis_lazuli',
		# 			  'minecraft:lapis_lazuli',
		# 			  'minecraft:lapis_lazuli',
		# 			  'minecraft:lapis_lazuli',
		# 	]

		for i in range(1, 17):
			self.__turtle.select(i)
			item_detail = self.__turtle.getItemDetail()
			if item_detail is not None and item_detail['name'] in black_list:
				self.__turtle.dropDown()

	def dig_col(self, num_steps: int = 1):
		for i in range(num_steps):
			step_success = False
			for attempt_idx in range(500):
				if step_success:
					break
				self.__turtle.dig()
				step_success = self.forward()
			self.__turtle.digUp()
			self.__turtle.digDown()

	def turn(self, turn_right, num_steps=1):
		if turn_right:
			self.turn_right(num_steps=num_steps)
		else:
			self.turn_left(num_steps=num_steps)

	def face_orientation(self, orientation: str):
		while self.orientation != orientation:
			self.turn_right()

	def go_to(self, x: int, y: int, z: int):
		print(f'x: {self.__x_offset} -> {x}')
		print(f'y: {self.__y_offset} -> {y}')
		print(f'z: {self.__z_offset} -> {z}')


		if self.__y_offset > y:
			self.dig_go_down(abs(y - self.__y_offset))
		elif self.__y_offset < y:
			self.dig_go_up(abs(y - self.__y_offset))

		if self.__x_offset > x:
			print('backward')
			self.face_orientation('S')
			self.dig_go_forward(abs(x - self.__x_offset))
		elif self.__x_offset < x:
			print('forward')
			self.face_orientation('N')
			self.dig_go_forward(abs(x - self.__x_offset))

		if self.__z_offset > z:
			self.face_orientation('O')
			self.dig_go_forward(abs(z - self.__z_offset))
		elif self.__z_offset < z:
			self.face_orientation('E')
			self.dig_go_forward(abs(z - self.__z_offset))
		self.face_orientation('N')

	def return_home(self):
		self.go_to(x=0, y=0, z=0)

	def calibrate(self, radius: int = 10):
		self.dig_col()

		while self.dig_go_down():
			pass

		success = False
		while not success:
			checkpoint_x, checkpoint_y, checkpoint_z = self.__x_offset, self.__y_offset, self.__z_offset

			success = True
			for orientation in self.__compass:
				self.face_orientation(orientation=orientation)

				op_success = self.dig_go_forward(num_steps=radius)
				success = success and op_success

				self.go_to(x=checkpoint_x, y=checkpoint_y, z=checkpoint_z)
				if not op_success:
					break
			if not success:
				self.up()

		bottom_y_offset = self.__y_offset
		origin_abs_y = -59 + abs(bottom_y_offset)

		self.return_home()
		return origin_abs_y

	def quarry(self, length, width, depth, down_on_start):  # length ^ width >
		going_away = True

		self.dig_col()

		self.down(down_on_start)

		for i in range(depth):
			for j in range(width):
				if self.__turtle.getFuelLevel() < self.manhattan_dist_origin + 100:
					self.return_home()
					return

				self.dig_col(length)

				if j != width-1:
					self.turn(turn_right=going_away)
					self.dig_col()
					self.turn(turn_right=going_away)
					going_away = not going_away
				self.sanitize_inventory()

			if i != depth - 1:
				self.dig_go_down(num_steps=3)
				self.__turtle.digDown()
				self.turn(turn_right=True)
				self.turn(turn_right=True)

		self.return_home()

	def dig_mineral_layer(self, length: int, width: int, mineral: str):
		mineral_layers = {
			'coal': {'best': 96, 'max': 256, 'min': 0},
			'copper': {'best': 48, 'max': 112, 'min': -16},
			'iron': {'best': 16, 'max': 56, 'min': -24},
			'gold': {'best': -16, 'max': 32, 'min': -59},
			'diamond': {'best': -59, 'max': -15, 'min': -59},
			'redstone': {'best': -59, 'max': 16, 'min': -59},
			'lapis': {'best': 0, 'max': 64, 'min': -59},
			}

		mineral = mineral.lower()

		if mineral not in mineral_layers:
			print(f'>>> ERROR: Cant find layer data for {mineral}')
			return
		else:
			# Calibrate
			print('>>> Calculating home elevation...')
			self.__origin_abs_y = self.calibrate()
			print(f'>>> Home elevation is Y = {self.__origin_abs_y}')

			best_layer = mineral_layers[mineral]['best']




			top_bound = min(self.__origin_abs_y, mineral_layers[mineral]['max'])
			bottom_bound = max(mineral_layers[mineral]['min'], -59)

			down_on_start = self.__origin_abs_y - top_bound
			num_layers = (top_bound - bottom_bound) // 3

			# TODO FIX BOTTOM BOUND
			# if mineral_layers[mineral]['best'] - num_layers//2 * 3 < -59:
			# 	top_bound - num_layers*3
			# 	# min(self.__origin_abs_y, mineral_layers[mineral]['best'] + (num_layers // 2) * 3)
			# 	#
			# 	# num_layers(mineral_layers[mineral]['best'] - num_layers // 2 * 3) - 59

			print(f'>>> Best layer for {mineral} is Y = {best_layer}')
			print(f'>>> Quarry will be from Y = {top_bound} to Y = {bottom_bound}')
			print(f'>>> Going down {down_on_start} blocks')

			self.quarry(length=length, width=width, depth=num_layers, down_on_start=down_on_start)


smart_turtle = SmartTurtle()
print(smart_turtle.inventory)
# smart_turtle.go_to(x=8, y=0, z=0)
# smart_turtle.go_to(x=8, y=2, z=0)
# smart_turtle.go_to(x=4, y=0, z=4)
# smart_turtle.go_to(x=4, y=2, z=4)
# smart_turtle.go_to(x=8, y=0, z=8)
# smart_turtle.go_to(x=0, y=0, z=0)
# smart_turtle.dig_mineral_layer(length=LENGTH, width=WIDTH, mineral=MINERAL)
# smart_turtle.quarry(length=LENGTH, width=WIDTH, depth=DEPTH, down_on_start=DOWN_ON_START)
