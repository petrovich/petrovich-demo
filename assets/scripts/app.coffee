#= require evil-blocks
#= require evil-front/after

evil.block '.example-section', ($, b) ->
  example   = -> $.trim(b.example.val())
  nameParts = -> example().split(' ')
  howto     = $('.howto-section')

  prev = example()
  b.example.on 'change keyup', ->
    return if prev == example()
    prev = example()
    b.example.trigger 'update'

  clearOnFocus: ->
    b.example.click -> b.example.select()

  autodetectGender: ->
    b.example.on 'update', ->
      parts = nameParts()

      if parts.length == 3
        last = example()[-3..-1]
        if last == 'вич'
          b.male.prop(checked: true).change()
        else if last == 'вна'
          b.female.prop(checked: true).change()

  autoSend: ->
    b.gender.change -> b.form.submit()

    lastUp = null
    b.example.on 'update', ->
      clearTimeout(lastUp)
      lastUp = after 500, ->
        b.form.submit()

  ajax: ->
    b.form.submit ->
      return false if example() == ''

      parts = nameParts()
      data  =
        lastname:   parts[0]
        firstname:  parts[1]
        middlename: parts[2]
        gender:     b.gender.filter(':checked').val()

      $.post '/decline.json', data, (result) ->
        for gcase, i of result
          name = [i.lastname, i.firstname, i.middlename]
          b[gcase]?.text(name.join(' '))

        howto.trigger('update', [data, result])
      false

evil.block '.howto-section', ($, b, section) ->

  update: ->
    section.on 'update', (e, data, result) ->
      b.gender.text(':' + data.gender)
      b.lastname.text('"' + data.lastname + '"')
      b.genitive.text('=> "' + result.genitive.lastname + '"')
      b.dative.text('=> "' + result.dative.lastname + '"')
