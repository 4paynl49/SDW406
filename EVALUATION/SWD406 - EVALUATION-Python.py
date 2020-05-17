#!/usr/bin/env python3

import sqlite3
from datetime import datetime

shopper_id = None
conn = None
curs = None
basket_id = None

def _display_options(all_options, title, type):
    option_num = 1
    option_list = []
    print("\n", title, "\n")
    for option in all_options:
        code = option[0]
        desc = option[1]
        print("{0}.\t{1}".format(option_num, desc))
        option_num = option_num + 1
        option_list.append(code)
    selected_option = 0
    while selected_option > len(option_list) or selected_option == 0:
        prompt = "Enter the number against the "+type+" you want to choose: "
        selected_option = int(input(prompt))
    return option_list[selected_option - 1]

# Main menu
def main_menu():
	while True:
		print("""
ORINOCO - SHOPPER MAIN MENU

1.	Display your order history
2.	Add an item to your basket
3.	View your basket
4.	Checkout
5.	Exit.
""")

		option = int(input("> "))
		if option == 1:
			display_order_history()
		elif option == 2:
			add_item()
		elif option == 3:
			view_basket()
		elif option == 4:
			checkout()
		elif option == 5:
			print("Goodbye")
			break
		else:
			print("Invalid selection")


def display_order_history():
	print("Order History\n")

	curs.execute("""SELECT so.order_id, so.order_date, so.order_status, s.seller_name, op.quantity, op.price, p.product_description
FROM shopper_orders so
INNER JOIN ordered_products op ON so.order_id = op.order_id
INNER JOIN product_sellers ps ON op.product_id = ps.product_id AND op.seller_id = ps.seller_id
INNER JOIN products p ON ps.product_id = p.product_id
INNER JOIN sellers s ON ps.seller_id = s.seller_id
WHERE so.shopper_id='{0}'
ORDER BY so.order_date DESC, so.order_id""".format(shopper_id))

	all_rows = curs.fetchall()
	if len(all_rows) == 0:
		print("No orders placed by this customer")
	else:
		print("Order ID    Order Date     Product Description                                                                         Seller                     Price           Qty    Status\n")
		for row in all_rows:
			order_id = row[0]
			order_date = row[1]
			order_status = row[2]
			seller_name = row[3]
			quantity = row[4]
			price = row[5]
			product_description = row[6]
			print("{0}     {1}     {6:<70}                      {3:<24}   £{5:6.2f}      {4:>6}    {2}".
				format(order_id, order_date, order_status, seller_name, quantity, price, product_description))

def add_item():
	global basket_id

	print("Add item")

	# Get the product category
	curs.execute("""SELECT c.category_id, c.category_description
FROM categories c
ORDER BY category_description""")
	all_rows = curs.fetchall()
	category_id = _display_options(all_rows, "Product Categories", "product category")

	# Get the product
	curs.execute("""SELECT p.product_id, p.product_description
FROM products p
WHERE p.category_id = '{0}'
ORDER BY p.product_description""".format(category_id))
	all_rows = curs.fetchall()
	product_id = _display_options(all_rows, "Products", "product")

	# Get the seller
	curs.execute("""SELECT s.seller_id, s.seller_name
FROM sellers s, product_sellers ps
WHERE ps.seller_id = s.seller_id AND ps.product_id='{0}'
ORDER BY s.seller_name""".format(product_id))
	all_rows = curs.fetchall()
	seller_id = _display_options(all_rows, "Sellers who sell this product", "seller")

	# Get the price
	curs.execute("SELECT price FROM product_sellers WHERE product_id={0} AND seller_id={1}".format(product_id, seller_id))
	row = curs.fetchone()
	price = int(row[0])

	# Get the quantity
	quantity = int(input("Enter the quantity of the selected product you want to buy: "))

	# Get the next basket id, if we don't already have one.
	# Note this is insecure and the autoincrement value assigned should be retrieved after the INSERT with:
	# SELECT last_insert_rowid()
	if basket_id is None:
		curs.execute("SELECT seq+1 FROM sqlite_sequence WHERE name='shopper_baskets'")
		row = curs.fetchone()
		basket_id = int(row[0])
		now = datetime.now()
		curs.execute("""INSERT INTO shopper_baskets (basket_id, shopper_id, basket_created_date_time)
VALUES ({0}, {1}, '{2}')""".format(basket_id, shopper_id, now.strftime("%d/%m/%Y %H:%M:%S")))
		conn.commit()

	# Put the product in the basket
	curs.execute("""INSERT INTO basket_contents (basket_id, product_id, seller_id, quantity, price)
VALUES({0}, {1}, {2}, {3}, {4})
""".format(basket_id, product_id, seller_id, quantity, price))
	conn.commit()

def view_basket():
	if basket_id is None:
		print("No basket currently exists")
		return
	
	curs.execute("""SELECT p.product_description, s.seller_name, bc.quantity, bc.price
FROM basket_contents bc, product_sellers ps, sellers s, products p
WHERE bc.basket_id={0} AND bc.product_id = ps.product_id AND bc.seller_id = ps.seller_id AND
	ps.seller_id = s.seller_id AND ps.product_id = p.product_id
ORDER BY p.product_description
	""" .format(basket_id))
	all_rows = curs.fetchall()
	if len(all_rows) == 0:
		print("Basket is empty")
	else:
		print("Basket Contents\n")
		print("Product Description                                                  Seller Name                     Qty   Price\n")
		for row in all_rows:
			product_description = row[0]
			seller_name = row[1]
			quantity = row[2]
			price = row[3]
			print("{0:<70}     {1:<24}     {2:>6}   £{3:6.2f}".
                            format(product_description, seller_name, quantity, price))

def checkout():
	print("Checkout...")

##
## ENTRY POINT
##

# Connect to database and create a cursor
conn = sqlite3.connect("orinoco.db")
curs = conn.cursor()

# Get shopper id from user and check it's valid
selected_shopper_id = input("Enter shopper id: ")
curs.execute("SELECT shopper_account_ref FROM shoppers WHERE shopper_id='{0}'".format(selected_shopper_id))
if curs.fetchone() is None:
	print("No such account_id '{0}' found in database".format(selected_shopper_id))
	exit(1)

shopper_id = int(selected_shopper_id)

main_menu()

