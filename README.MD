https://factiondb.herokuapp.com/

This is an app that enables people to easily keep track of magic the gathering cards that they borrow from one another. Users can add cards they have for others to borrow by finding them through the mtg api and adding them to the database.

Other users can then see what cards are available to borrow and indicate they would like to borrow them.

When cards have physically changed hands, both users confirm that this has happened. When cards are returned both players would again have to confirm.

Mtg card borrow app database:

User:
	id:
	user_name:
	password:
	email:
	isadmin:

Trade:
	id:
	user_id_owner:
	user_id_borrower:
	card_id:
	amount:
	status: (requested, confirmed, returned, confirmed_returned)

Card:
	id:
	multiverse_id:
	user_id:
	amount:
	name:
	edition:
	image_url: