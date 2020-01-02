# Roadmap
* write Python executable
	* define inner snippet format
	* read snippets directory (same format as kakoune-snippet-collection) into the format
	* make executable return snippet content and placeholder desc when given the alias 
		* make it expand shell variables (lots of regex)
			* format ${1:default} and ${1!echo "$HOME"}
* integrate in kakoune as a plugin 
	* two-options:
		* use parts of the old kakoune-snippets plugin 
			* snippets-add 
		* write everything myself
	* create hooks in InsertMode depending on the presence of a default value (using selection descs)

# Syntax

snips <flags> <alias>
	-h show help
	-c print content of snippets <alias>
	-d print descs of placeholders
	-r define alternative repository (default one saved somewhere)
