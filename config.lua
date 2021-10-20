Config = {}

Config.CanhSat = 0

Config.LaMax = 20
Config.SayMax = 20
Config.price = 100

Config.Vitri = {
	Canhdong = {coords = vector3(1590.8684082031, -2001.5205078125, 95.394607543945)},
	Say = {coords = vector3(1396.2489, 3612.8669, 34.980922)},
    Ban = {coords = vector3(2319.851, 2581.5764, 46.653259)},
}

Config.Delays = {
	MTD = 1000 * 3
}
Config.SellItems = {
	['ic-mtdg'] = {
		['Type'] = 'money',
		['Amount'] = math.random(100, 125),
	},
}
