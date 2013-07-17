#= require evil-blocks
#= require evil-front/after

evil.block '.example-section', ($, b) ->

  clearOnFocus: ->
    b.example.focus -> b.example.select()

  autodetectGender: ->
    b.example.on 'change keyup', ->
      parts = $.trim($(@).val()).split(' ')

      if parts.length == 3
        last = parts[2][-3..-1]
        if last == 'вич'
          b.male.prop(checked: true)
        else if last == 'вна'
          b.female.prop(checked: true)

  autoSend: ->
    lastUp = null
    b.example.on 'change keyup', ->
      clearTimeout(lastUp)
      lastUp = after 500, ->
        b.form.submit()

  ajax: ->
    b.form.submit ->
      console.log('send')
      false
