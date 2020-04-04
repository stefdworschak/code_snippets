# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', () =>

    $('.edit-comment').on 'click', (event) =>
        edit_btn = $(event.currentTarget)
        comment = edit_btn.parent().parent().parent().parent().children().eq(1).children()
        comment.eq(0).hide()
        comment.eq(1).show()
        console.log comment