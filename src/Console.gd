
extends CanvasLayer

const BaseCommands = preload('BaseCommands.gd')
const Callback = preload('../vendor/quentincaffeino/callback/src/Callback.gd')
const Group = preload('Command/Group.gd')

### Custom console types
const IntRange = preload('Types/IntRange.gd')
const FloatRange = preload('Types/FloatRange.gd')
const Filter = preload('Types/Filter.gd')


# @deprecated
# @var  Commands
var _Commands = preload('Commands.gd').new()

# @var  History
var History = preload('History.gd').new() setget _setProtected

# @var  Log
var Log = preload('Log.gd').new() setget _setProtected

# @var  RegExLib
var RegExLib = preload('RegExLib.gd').new() setget _setProtected

# @var  Command/Group
var _rootGroup

# Used to clear text from bb tags
# @var  RegEx
var _eraseTrash

# @var  bool
var isConsoleShown = true setget _setProtected

# @var  bool
var submitAutocomplete = true

# @var  string
export(String) var action_console_toggle = 'console_toggle'

# @var  string
export(String) var action_history_up = 'ui_up'

# @var  string
export(String) var action_history_down = 'ui_down'


### Console nodes
onready var _consoleBox = $ConsoleBox
onready var Text = $ConsoleBox/Container/ConsoleText setget _setProtected
onready var Line = $ConsoleBox/Container/ConsoleLine setget _setProtected
onready var _animationPlayer = $ConsoleBox/AnimationPlayer


func _init():
  self._rootGroup = Group.new('root')
  # Used to clear text from bb tags
  self._eraseTrash = RegExLib.getPatternFor('console.eraseTrash')


func _ready():
  # Allow selecting console text
  self.Text.set_selection_enabled(true)
  # Follow console output (for scrolling)
  self.Text.set_scroll_follow(true)
  # React to clicks on console urls
  self.Text.connect('meta_clicked', self.Line, 'setText')

  # Hide console by default
  self._consoleBox.hide()
  self._animationPlayer.connect("animation_finished", self, "_toggleAnimationFinished")
  self.toggleConsole()

  # Console keyboard control
  set_process_input(true)

  # Show some info
  var v = Engine.get_version_info()
  writeLine(\
    ProjectSettings.get_setting("application/config/name") + \
    " (Godot " + str(v.major) + '.' + str(v.minor) + '.' + str(v.patch) + ' ' + v.status+")\n" + \
    "Type [color=#ffff66][url=help]help[/url][/color] to get more information about usage")

  # Init base commands
  self.BaseCommands.new()


# @param  Event  e
func _input(e):
  if Input.is_action_just_pressed(self.action_console_toggle):
    self.toggleConsole()


# @param  string  name
func getCommand(name):  # Command/CommandHandler|null
  return self._rootGroup.getCommand(name)


# @param  string  name
# @param  Array   parparametersams
func register(name, parameters = []):  # bool
  return self._rootGroup.registerCommand(name, parameters)


# TODO: Map onto new groups system
# @param  string  name
func unregister(name):  # int
  return self._Commands.unregister(name)


# @param  string  message
func write(message):  # void
  message = str(message)
  self.Text.set_bbcode(self.Text.get_bbcode() + message)
  print(self._eraseTrash.sub(message, '', true))
  

# @param  string  message
func writeLine(message = ''):  # void
  message = str(message)
  self.Text.set_bbcode(self.Text.get_bbcode() + message + '\n')
  print(self._eraseTrash.sub(message, '', true))


func clear():  # void
  self.Text.set_bbcode('')


func toggleConsole():  # void
  # Open the console
  if !isConsoleShown:
    self._consoleBox.show()
    self.Line.clear()
    self.Line.grab_focus()
    self._animationPlayer.play_backwards('fade')
  else:
    self._animationPlayer.play('fade')

  isConsoleShown = !isConsoleShown


func _toggleAnimationFinished(animation):  # void
  if !isConsoleShown:
    self._consoleBox.hide()


func _setProtected(value):  # void
  Log.warn('QC/Console: setProtected: Attempted to set a protected variable, ignoring.')
