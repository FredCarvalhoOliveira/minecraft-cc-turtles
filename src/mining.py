from cc import turtle as cc_turtle


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

	def turn_right(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.turnRight()
			self.__curr_orient_idx += 1

	def turn_left(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.turnLeft()
			self.__curr_orient_idx -= 1

	def forward(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.forward()

			if self.orientation == 'N':
				self.__x_offset += 1
			elif self.orientation == 'S':
				self.__x_offset -= 1
			elif self.orientation == 'E':
				self.__z_offset += 1
			elif self.orientation == 'O':
				self.__z_offset -= 1

	def back(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.back()

			if self.orientation == 'N':
				self.__x_offset -= 1
			elif self.orientation == 'S':
				self.__x_offset += 1
			elif self.orientation == 'E':
				self.__z_offset -= 1
			elif self.orientation == 'O':
				self.__z_offset += 1

	def up(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.up()
			self.__y_offset += 1

	def down(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.down()
			self.__y_offset -= 1

	def sanitize_inventory(self):
		black_list = ['minecraft:cobblestone',
					  'minecraft:dirt',
					  'minecraft:gravel',
					  'minecraft:sand',
					  'minecraft:andesite',
					  'minecraft:granite',
					  'minecraft:diorite']
		for i in range(1, 17):
			self.__turtle.select(i)
			item_detail = self.__turtle.getItemDetail()
			if item_detail is not None and item_detail['name'] in black_list:
				self.__turtle.dropDown()

	def dig_col(self, num_steps: int = 1):
		for i in range(num_steps):
			self.__turtle.dig()
			self.forward()
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
			self.up(self.__y_offset)

		if self.__x_offset > 0:
			self.face_orientation('S')
			self.forward(self.__x_offset)
		elif self.__x_offset < 0:
			self.face_orientation('N')
			self.forward(self.__x_offset)

		if self.__z_offset > 0:
			self.face_orientation('O')
			self.forward(self.__z_offset)
		elif self.__z_offset < 0:
			self.face_orientation('E')
			self.forward(self.__z_offset)

	def quarry(self, length, width, depth):  # length ^ width >
		going_away = True

		self.dig_col()

		for i in range(depth):
			for j in range(width):
				self.dig_col(length)

				if j != width-1:
					self.turn(turn_right=going_away)
					self.dig_col()
					self.turn(turn_right=going_away)
					going_away = not going_away
				self.sanitize_inventory()

			if i != depth - 1:
				self.down()
				self.__turtle.digDown()
				self.down()
				self.__turtle.digDown()
				self.down()
				self.__turtle.digDown()
				self.turn(turn_right=True)
				self.turn(turn_right=True)

		self.return_home()





# def dig_col():
# 	turtle.dig()
# 	turtle.forward()
# 	turtle.digUp()
# 	turtle.digDown()
#
#
# def dig_tunnel(depth):
# 	for i in range(depth):
# 		dig_col()
#
#
# def turn(turn_right):
# 	if turn_right:
# 		turtle.turnRight()
# 	else:
# 		turtle.turnLeft()
#
#
# def strip_mine(tunnel_depth, num_tunnels):
# 	going_away = True
#
# 	dig_col()
#
# 	for i in range(num_tunnels):
# 		dig_tunnel(tunnel_depth)
#
# 		turn(turn_right=going_away)
#
# 		dig_col()
# 		dig_col()
# 		dig_col()
# 		dig_col()
# 		dig_col()
# 		turtle.back()
# 		turtle.back()
#
# 		turn(turn_right=going_away)
#
# 		going_away = not going_away
#
# 		sanitize_inventory()
#
#
# def full_mine(length, width, depth):  # length ^ width >
# 	going_away = True
#
# 	dig_col()
#
# 	for i in range(depth):
# 		for j in range(width):
# 			dig_tunnel(length)
#
# 			if j != width-1:
# 				turn(turn_right=going_away)
# 				dig_col()
# 				turn(turn_right=going_away)
# 				going_away = not going_away
# 			sanitize_inventory()
#
# 		if i != depth - 1:
# 			turtle.down()
# 			turtle.digDown()
# 			turtle.down()
# 			turtle.digDown()
# 			turtle.down()
# 			turtle.digDown()
# 			turn(turn_right=True)
# 			turn(turn_right=True)
#
# 	for i in range(depth):
# 		turtle.up()
#
#
#
# # strip_mine(tunnel_depth=20, num_tunnels=10)
# full_mine(2, 2, 2)

smart_turtle = SmartTurtle()
smart_turtle.quarry(5, 5, 2)
