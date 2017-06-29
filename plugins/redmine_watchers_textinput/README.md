redmine watchers textinput
==========================

### Features 

This is a plugin that replaces the checkboxes for adding watchers with a nice, tokenized text input with autocomplete. The actual Redmine plugin name is "redmine_watchers_textinput". The pages that are modified are the "Add new issue" page and "Edit watchers" (on existing issue) popup.

### Compatibility

Redmine 2.5.x

### Technical info

This plugin effectively still uses the checkbox inputs but makes them hidden. The autocomplete script effectively reads what's in the checkboxes to get the list of users, and will "check" in the checkboxes. This way I didn't have to change what the server-side is expecting in the form submission.

It does at least replace one view (*erb) so it is probably not super portable.

The actual autocomplete plugin used is Select2 (http://ivaynberg.github.io/select2/)

### How to install ?

Just copy the "redmine_watchers_textinput" folder to your plugins directory and activate.