#= require evil-blocks

$(document).ready ->

  input  = $('@input-name')
  male   = $('@male')
  female = $('@female')

  input.click -> $(@).select()

  input.on 'change keyup', ->
    parts = $.trim($(@).val()).split(' ')

    if parts.length == 3
      last = parts[2][-3..-1]
      if last == 'вич'
        male.prop(checked: true)
      else if last == 'вна'
        female.prop(checked: true)
