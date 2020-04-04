# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery
editor = null
$(document).on 'turbolinks:load', () =>
    code_snippets = $('.snip-body > pre')
    count = 0
    for code_snippet in code_snippets
        code = []
        snip = code_snippets.eq(count)
        lines = snip.text().split("\n")
        snip.text("")
        while lines.length > 0
            line = lines.shift()
            span = $("<span></span>")
            span.text(line)
            snip.append(span.text(line))
            if lines.length > 0
                snip.append("\n")
        count++
    
    $('[data-toggle="tooltip"]').tooltip()
    