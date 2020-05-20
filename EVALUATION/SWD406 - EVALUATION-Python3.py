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
		print("""\n\n\n
 ORINOCO - SHOPPER MAIN MENU

1.	Display your order history
2.	Add an item to your basket
3.	View your basket
4.	Checkout
5.	Exit.
\n\n\n""")

		option = int(input("> "))
		if option == 1:
			display_order_history()
		elif option == 2:
			add_item()
		elif option == 3:
			view_basket(False)		# Don't display totals
		elif option == 4:
			checkout()
		elif option == 5:
			print("Goodbye")
			break
		else:
			print("Invalid selection")


def display_order_history():
	print("Order History\n")

	curs.execute("""""".format(shopper_id))

	all_rows = curs.fetchall()
	if len(all_rows) == 0:
		print("No orders placed by this customer")
	else:
		print("Order ID   Order Date    Product Description                                                                        Seller                     Price            Qty   Status\n")
		for row in all_rows:
			order_id = row[0]
			order_date = row[1]
			order_status = row[2]
			seller_name = row[3]
			quantity = row[4]
			price = row[5]
			product_description = row[6]
			print("{0}    {1}    {6:<70}                     {3:<24}   £{5:6.2f}      {4:>6}    {2}".
				format(order_id, order_date, order_status, seller_name, quantity, price, product_description))

def add_item():
	global basket_id

	print("Add item\n")

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
	curs.execute("""SELECT s.seller_id, s.seller_name|| printf(' (£%.2f)', ps.price)
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

	# Create the basket if it does not exist.  Note we allow basket_id to be auto-populated and then we
	# retrieve the assigned ID by fetching last_insert_row() back.  This makes the transaction secure if
	# multiple clients are doing this at the same time...
	if basket_id is None:
		now = datetime.now()
		curs.execute("""INSERT INTO shopper_baskets (shopper_id, basket_created_date_time)
VALUES ({0}, '{1}')""".format(shopper_id, now.strftime("%d/%m/%Y %H:%M:%S")))
		conn.commit()
		curs.execute("SELECT last_insert_rowid()")
		row = curs.fetchone()
		basket_id = int(row[0])

	# Put the product in the basket
	curs.execute("""INSERT INTO basket_contents (basket_id, product_id, seller_id, quantity, price)
VALUES({0}, {1}, {2}, {3}, {4})
""".format(basket_id, product_id, seller_id, quantity, price))
	conn.commit()

# Returns False if the basket does not exist or is empty.
# If display_total is True then display the grand total of the basket.
def view_basket(display_total):
	if basket_id is None:
		print("No basket currently exists")
		return False
	
	curs.execute("""SELECT p.product_description, s.seller_name, bc.quantity, bc.price
FROM basket_contents bc, product_sellers ps, sellers s, products p
WHERE bc.basket_id={0} AND bc.product_id = ps.product_id AND bc.seller_id = ps.seller_id AND
	ps.seller_id = s.seller_id AND ps.product_id = p.product_id
ORDER BY p.product_description
	""" .format(basket_id))
	all_rows = curs.fetchall()
	if len(all_rows) == 0:
		print("Basket is empty")
		return False

	total = 0
	print("Basket Contents\n")
	print("Product Description                                                        Seller Name                     Qty   Price\n")
	for row in all_rows:
		product_description = row[0]
		seller_name = row[1]
		quantity = row[2]
		price = row[3]
		total += price * quantity
		print("{0:<70}     {1:<24}     {2:>6}   £{3:6.2f}".format(product_description, seller_name, quantity, price))
	if display_total:
		print("                                                                                                         Total: £{0:6.2f}".format(total))
	return True

def checkout():
	global basket_id

	if not view_basket(True):	# Display total
		return					# Basket does not exist/is empty

	# Get the delivery address
	curs.execute("""SELECT DISTINCT sda.delivery_address_id, sda.delivery_address_line_1||', '||sda.delivery_address_line_2||', '||IFNULL(sda.delivery_address_line_3 , '')||', '||sda.delivery_county||', '||sda.delivery_post_code AS delivery_address
FROM shopper_delivery_addresses sda, shopper_orders so
WHERE so.shopper_id={0} and sda.delivery_address_id = so.delivery_address_id
ORDER BY so.order_date DESC""".format(shopper_id))

	all_rows = curs.fetchall()
	delivery_address_id = None
	if len(all_rows) == 0:
		print("As you have not yet placed any orders, you will need to enter a delivery address\n")
		new_address = {}
		new_address["line_1"] = input("Enter the delivery address line 1: ")
		new_address["line_2"] = input("Enter the delivery address line 2: ")
		new_address["line_3"] = input("Enter the delivery address line 3: ")
		new_address["county"] = input("Enter the delivery county: ")
		new_address["postcode"] = input("Enter the delivery postcode: ")
		curs.execute("""INSERT INTO shopper_delivery_addresses (delivery_address_line_1, delivery_address_line_2, delivery_address_line_3, delivery_county, delivery_post_code)
VALUES('{0}', '{1}', '{2}', '{3}', '{4}')""" .format(new_address["line_1"], new_address["line_2"], new_address["line_3"], new_address["county"], new_address["postcode"]))
		conn.commit()
		curs.execute("SELECT last_insert_rowid()")
		row = curs.fetchone()
		delivery_address_id = int(row[0])
	elif len(all_rows) == 1:
		delivery_address_id = all_rows[0][0]
	else:
		delivery_address_id = _display_options(all_rows, "Delivery Addresses", "delivery address")

	# Get the payment card
	curs.execute("""SELECT DISTINCT spc.payment_card_id, spc.card_type || ' ending in ' || spc.card_number
FROM shopper_payment_cards spc, shopper_orders so
WHERE so.shopper_id={0} and spc.payment_card_id = so.payment_card_id
ORDER BY so.order_date DESC""".format(shopper_id))

	all_rows = curs.fetchall()
	payment_card_id = None
	if len(all_rows) == 0:
		print("As you have not yet placed any orders, you will need to enter your payment card details\n")
		new_card = {}
		new_card["type"] = input("Enter the card type (Visa, Mastercard or AMEX): ")
		new_card["number"] = input("Enter the 16-digit card number: ")
		curs.execute("INSERT INTO shopper_payment_cards (card_type, card_number) VALUES('{0}', '{1}')".format(new_card["type"], new_card["number"]))
		conn.commit()
		curs.execute("SELECT last_insert_rowid()")
		row = curs.fetchone()
		payment_card_id = int(row[0])
	elif len(all_rows) == 1:
		payement_card_id = all_rows[0][0]
	else:
		payment_card_id = _display_options(all_rows, "Payment Cards", "payment card")

	# Add new order
	now = datetime.now()
	curs.execute("""INSERT INTO shopper_orders (shopper_id, delivery_address_id, payment_card_id, order_date, order_status)
VALUES({0}, {1}, {2}, '{3}', '{4}')""".format(shopper_id, delivery_address_id, payment_card_id, now.strftime("%d/%m/%Y %H:%M:%S"), "Placed"))
	conn.commit()

	# Move basket contents into ordered_products table
	curs.execute("""INSERT INTO ordered_products (product_id, seller_id, quantity, price, ordered_product_status)
SELECT product_id, seller_id, quantity, price, '{1}' FROM basket_contents WHERE basket_id={0}""".format(basket_id, "Placed"))
	curs.execute("DELETE FROM basket_contents WHERE basket_id={0}".format(basket_id))
	conn.commit()

	print("Checkout complete, your order has been placed")

	# Any new products will go into a new basket
	basket_id = None

##
## ENTRY POINT
##

# Connect to database and create a cursor
conn = sqlite3.connect("orinoco.db")
curs = conn.cursor()

# Get shopper id from user and check it's valid
selected_shopper_id = input("Enter shopper id: ")
curs.execute("SELECT COUNT(*) FROM shoppers WHERE shopper_id='{0}'".format(selected_shopper_id))
row = curs.fetchone()
if row[0] != 1:
	print("No such account_id '{0}' found in database".format(selected_shopper_id))
	exit(1)

shopper_id = int(selected_shopper_id)

main_menu()

