extends CanvasLayer

var coins := 0

func add_coin(amount := 1):
	coins += amount
	%CoinLabel.text = str(coins) + "x"
