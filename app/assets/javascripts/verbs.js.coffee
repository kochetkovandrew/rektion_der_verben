# Place all the behaviors and hooks related to the matching controller here
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

VerbsForwardTest = () ->
  this.ids = new Array()
  this.answerCount = new Array()
  this.checkingEntity = ''
  this.checkingIdx = 0
  this.errorCount = 0
  if $('#ids').length
    this.ids = $('#ids').val().split(',')
    for i in [0..this.ids.length-1]
      this.answerCount[i] = 0
    $('button#check').bind "click",
      thisObj: this
      element: 'button#check'
    , (eventData) ->
      eventData.data.thisObj.checkAnswer eventData.data.element
    this.newQuestion()
    $('div#right').hide()
    $('div#wrong').hide()

VerbsForwardTest.prototype.nonCheckedCount = () ->
  cnt = 0
  for i in [0..this.ids.length-1]
    if this.answerCount[i] < 3
      cnt++
  return cnt

VerbsForwardTest.prototype.selectNonChecked = (idx) ->
  j = 0
  for i in [0..this.ids.length-1]
    if this.answerCount[i] < 3
      if j == idx
        return i
      else
        j++

VerbsForwardTest.prototype.newQuestion = () ->
  cnt = this.nonCheckedCount()
  self = this
  $('p#right_answers').text(t()['you_know'] + ': ' + (this.ids.length-cnt) + '/' + this.ids.length + ' ' + t()['words'])
  if cnt == 0
    $('p#verb').html('<h1>' + t()['all_is_ok'] + '</h1>')
  else
    qidx = Math.floor(Math.random() * (cnt))
    idx = this.selectNonChecked(qidx)
    id = this.ids[idx]
    $.ajax
      url: '/verbs/' + id + '/forward_test_step.json'
      context: self
      success: (data) ->
        this.checkingEntity = data.verb
        this.checkingIdx = idx
        $('div#quiz p#verb').html('<button type="button" class="btn btn-info btn-xlarge"><h1>' + data.verb.verb + '</h1></button>')
        # translations
        elem=$('<p></p>')
        for i in [0..data.translations.length-1]
          x = $('<label class="radio clickable_translation"></label>')
          str = data.translations[i][0]
          if data.translations[i][1] != null
            str += ' ('
            str += data.translations[i][1]
            str += ')'
          x.append($('<input type="radio" name="translation" value="' + data.translations[i][0] + '">'))
          x.append(str)
          elem.append(x)
        $('p#translations').append('<h3>' + t()['translation'].toUpperCase() + '</h3>')
        $('p#translations').append(elem)
        # prepositions
        elem=$('<p></p>')
        for i in [0..data.prepositions.length-1]
          x = $('<label class="radio inline clickable_preposition"></label>')
          x.append($('<input type="radio" name="preposition" value="'+ data.prepositions[i] + '">'))
          x.append(data.prepositions[i])
          elem.append(x)
        $('p#prepositions').append('<h3>' + t()['preposition'].toUpperCase() + '</h3>')
        $('p#prepositions').append(elem)
  
VerbsForwardTest.prototype.checkAnswer = (element) ->
  console.log $('input:radio[name="case"]:checked').val()
  console.log this.checkingEntity.case
  right = (this.checkingEntity.translation == $('input:radio[name="translation"]:checked').val()) && (this.checkingEntity.preposition == $('input:radio[name="preposition"]:checked').val())
  if this.checkingEntity.case != null
    right &&= (this.checkingEntity.case == $('input:radio[name="case"]:checked').val())
  if right
    $('div#right').show()
    $('div#wrong').hide()
    this.answerCount[this.checkingIdx]++
    $('p#verb').text('')
    $('p#translations').text('')
    $('p#prepositions').text('')
    $('input:radio[name="case"]').prop('checked', false)
    this.newQuestion()
  else
    $('div#right').hide()
    $('div#wrong').show()
    this.answerCount[this.checkingIdx] = 0
    this.errorCount++
    $('p#error_count').text(t()['incorrect_answers'] + ': ' + this.errorCount)

myTest = ''

jQuery ->
  if $('#page_id').length && ($('#page_id').val() == 'verbs_forward_test') 
    myTest = new VerbsForwardTest()

