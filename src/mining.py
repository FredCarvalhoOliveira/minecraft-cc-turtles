from cc import turtle as cc_turtle

LENGTH = 16
WIDTH = 5
DEPTH = 8

DOWN_ON_START = 91


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

	@property
	def orientation(self):
		return self.__compass[self.__curr_orient_idx]

	@property
	def manhattan_dist_origin(self):
		return abs(self.__x_offset) + abs(self.__y_offset) + abs(self.__z_offset)

	@property
	def inventory(self):
		inventory = {}

		return inventory

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
			self.__turtle.up()
			self.__y_offset += 1

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
			self.__turtle.dig()
			op_success = self.forward()
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

	def return_home(self):
		if self.__y_offset > 0:
			self.down(self.__y_offset)
		elif self.__y_offset < 0:
			self.up(abs(self.__y_offset))

		if self.__x_offset > 0:
			self.face_orientation('S')
			self.forward(self.__x_offset)
		elif self.__x_offset < 0:
			self.face_orientation('N')
			self.forward(abs(self.__x_offset))

		if self.__z_offset > 0:
			self.face_orientation('O')
			self.forward(self.__z_offset)
		elif self.__z_offset < 0:
			self.face_orientation('E')
			self.forward(abs(self.__z_offset))
		self.face_orientation('N')

	def calibrate(self, radius: int = 10):
		while self.dig_go_down():
			pass

		original_home = (self.__x_offset, self.__y_offset, self.__z_offset)

		success = False
		while not success:
			# set temp home
			self.__x_offset, self.__y_offset, self.__z_offset = 0, 0, 0

			success = True
			for orientation in self.__compass:
				self.face_orientation(orientation=orientation)

				op_success = self.dig_go_forward(num_steps=radius)
				success = success and op_success
				self.return_home()
			if not success:
				self.up()

		self.__x_offset, self.__y_offset, self.__z_offset = original_home
		return abs(self.__y_offset)







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


smart_turtle = SmartTurtle()
print(smart_turtle.calibrate(radius=10))
# smart_turtle.quarry(length=LENGTH, width=WIDTH, depth=DEPTH, down_on_start=DOWN_ON_START)
