map global user g ':goyo-enable<ret>'
define-command goyo-enable -docstring "TODO" %{
	remove-highlighter window/numbers
	add-highlighter window/numbers          number-lines -separator " "
	face global LineNumbers rgb:999999+d
}

define-command goyo-disable -docstring "TODO" %{

}
