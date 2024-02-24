from cc import turtle


def sanitize_inventory():
	black_list = ['minecraft:cobblestone',
				  'minecraft:dirt',
				  'minecraft:gravel',
				  'minecraft:sand',
				  'minecraft:andesite',
				  'minecraft:granite',
				  'minecraft:diorite']
	for i in range(1, 17):
		item_detail = turtle.getItemDetail(i)
		if item_detail['name'] in black_list:
			turtle.dropDown()


def dig_col():
	turtle.dig()
	turtle.forward()
	turtle.digUp()
	turtle.digDown()


def dig_tunnel(depth):
	for i in range(depth):
		dig_col()


def strip_mine(tunnel_depth, num_tunnels):
	dir_away = True

	for i in range(num_tunnels):
		dig_tunnel(tunnel_depth)
		if dir_away:
			turtle.turnRight()
		else:
			turtle.turnLeft()
		dig_col()
		dig_col()
		dig_col()
		dig_col()
		dig_col()
		turtle.back()
		turtle.back()

		if dir_away:
			turtle.turnRight()
		else:
			turtle.turnLeft()

		dir_away = not dir_away

		sanitize_inventory()

strip_mine(tunnel_depth=20, num_tunnels=10)









