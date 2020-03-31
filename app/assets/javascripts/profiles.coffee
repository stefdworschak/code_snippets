# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery
editor = null
$(document).on 'turbolinks:load', () =>
    $('#new-snippet').on 'click', () =>
        $('#display-snippets').hide()
        $('.create-snippet').css('display', 'block')
        myTextarea = $("#snippet_code")[0];
        editor = CodeMirror.fromTextArea(myTextarea, {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-csrc"
        });
        editor.on 'change', (event) =>
            $('#char-value').text(editor.getValue().length)

        editor.on 'change', (cm, changes) =>
            editor.eachLine(lineFunc)


lineFunc = (line) ->
    if line.text.length > 80 
        editor.addLineClass(line, "background", "tooLong")
            