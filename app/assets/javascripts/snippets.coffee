# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () =>

    $('.copy-snippet').on 'click', (event) =>
        link = event.currentTarget
        parent = $(link).parent().parent().parent()
        snippet_content = parent.children().eq(1).text()
        $(document.body).append('<textarea style="opacity:0" class="text-to-copy"></textarea>')
        $('.text-to-copy').val(snippet_content.trim())
        $('.text-to-copy')[0].select()
        document.execCommand('copy')
        $('.text-to-copy').remove()

    myTextarea = $("#snippet_code")[0];
    if myTextarea != undefined
        editor = CodeMirror.fromTextArea(myTextarea, {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-csrc"
        });

        editor.on 'change', (event) =>
            $('#char-value').text(editor.getValue().length)
