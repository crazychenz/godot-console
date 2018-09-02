

Godot Console
============

In-game console for Godot, easily extensible with new commands.

![Quake-style console for Godot](https://github.com/QuentinCaffeino/godot-console/blob/master/screenshot.png)

## Features

- Writing to console using `write` and `writeLine` method. You can use [BB codes](https://godot.readthedocs.io/en/latest/learning/features/gui/bbcode_in_richtextlabel.html?highlight=richtextlabel#reference). (Also printed to engine output)

	`Console.writeLine('Hello world!')`

- Auto-completion on `TAB` (complete command), `Enter` (complete and execute).
- History (by default using with actions `ui_up` and `ui_down`)
- Custom types (`Filter`, `IntRange`, `FloatRange`, [and more...](https://github.com/QuentinCaffeino/godot-console/blob/master/docs/Types/Types.md))
- [Logging](https://github.com/QuentinCaffeino/godot-console/tree/master/docs/Log.md)

## Installation

1. Clone or download this repository to your project folder.
2. Add `src/Console.tscn` to godot autoload as `Console`.
3. Add new actions to Input Map: `console_toggle`, `ui_up`, `ui_down`

## Example

### Registering command:

```gdscript
func _ready():
	Console.register('sayHello', { # Command name

		'description': 'Prints "Hello %name%!"',

		# This argument is obsolete if target function doesn't take any arguments.
		# If target is a variable then it takes one argument to set it, and zero to get its value.
		# You can fild more about how argument should look like below.
		# ARGUMENT[]
		'args': [[ 'name', TYPE_STRING ]],

		# Target to bind command to.
		# Providing name is obsolete if it is same as a command name.
			# [Object, variable/method name]
		'target': [ self, 'printHello' ]

	})

func printHello(name = ''):
	Console.writeLine('Hello ' + name + '!')
```

***ARGUMENT*** should look like this:
- [ 'arg_name', [**ARG_TYPE**](https://github.com/QuentinCaffeino/godot-console/blob/master/docs/Types/Types.md) ]
- 'arg_name' — In this situation type will be set to Any
- [**ARG_TYPE**](https://github.com/QuentinCaffeino/godot-console/blob/master/docs/Types/Types.md)

More information about [**ARG_TYPE**](https://github.com/QuentinCaffeino/godot-console/blob/master/docs/Types/Types.md) you can find [here](https://github.com/QuentinCaffeino/godot-console/blob/master/docs/Types/Types.md).

More examples in [`src/BaseCommands.gd`](https://github.com/QuentinCaffeino/godot-console/blob/master/src/BaseCommands.gd)

----------

Great thanks to [@Krakean](https://github.com/Krakean/godot-console) and [@DmitriySalnikov](https://github.com/DmitriySalnikov/godot-console) for the motivation to keep improving the [original](https://github.com/Calinou/godot-console) console by [@Calinou](https://github.com/Calinou).

Take a look at their implementations.

## License

Licensed under the MIT license, see `LICENSE.md` for more information.
