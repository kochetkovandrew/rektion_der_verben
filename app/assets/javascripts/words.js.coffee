# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

WordsForwardTest = () ->
  this.ids = new Array()
  this.answerCount = new Array()
  this.checkingEntity = ''
  this.checkingIdx = 0
  this.errorCount = 0

  $('div#article').hide()
  
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

WordsForwardTest.prototype.nonCheckedCount = () ->
  cnt = 0
  for i in [0..this.ids.length-1]
    if this.answerCount[i] < 3
      cnt++
  return cnt

WordsForwardTest.prototype.selectNonChecked = (idx) ->
  j = 0
  for i in [0..this.ids.length-1]
    if this.answerCount[i] < 3
      if j == idx
        return i
      else
        j++

WordsForwardTest.prototype.newQuestion = () ->
  cnt = this.nonCheckedCount()
  self = this
  $('p#right_answers').text('Sie weißen: ' + (this.ids.length-cnt) + '/' + this.ids.length + ' Wörter')
  if cnt == 0
    $('div#article').hide()
    $('p#entity').html('<h1>ALLES GUT!</h1>')
  else
    qidx = Math.floor(Math.random() * (cnt))
    idx = this.selectNonChecked(qidx)
    id = this.ids[idx]
    $.ajax
      url: '/words/' + id + '/forward_test_step.json'
      context: self
      success: (data) ->
        this.checkingEntity = data.entity
        this.checkingIdx = idx
        $('div#quiz p#entity').html('<button type="button" class="btn btn-info btn-xlarge"><h1>' + data.entity.word + '</h1></button>')
        # translations
        elem=$('<p></p>')
        for i in [0..data.translations.length-1]
          x = $('<label class="radio clickable_translation"></label>')
          str = data.translations[i]
          x.append($('<input type="radio" name="translation" value="' + data.translations[i] + '">'))
          x.append(str)
          elem.append(x)
        $('p#translations').append('<h3>' + t()['translation'].toUpperCase() + '</h3>')
        $('p#translations').append(elem)
        $('input[name=article]').attr('checked', false)
        if data.entity.speech_part == 'noun'
          $('div#article').show()
        else
          $('div#article').hide()

WordsForwardTest.prototype.checkAnswer = (element) ->
  console.log this.checkingEntity.speech_part
  console.log this.checkingEntity.article
  console.log $('input:radio[name="article"]:checked').val()
  article_ok = (this.checkingEntity.speech_part != 'noun')
  if !article_ok
    article_ok = (this.checkingEntity.article == $('input:radio[name="article"]:checked').val()) 
  if (this.checkingEntity.translation == $('input:radio[name="translation"]:checked').val()) && article_ok
    $('div#right').show()
    $('div#wrong').hide()
    this.answerCount[this.checkingIdx]++
    $('p#entity').text('')
    $('p#translations').text('')
#    $('input:radio[name="case"]').prop('checked', false)
    this.newQuestion()
  else
    $('div#right').hide()
    $('div#wrong').show()
    this.answerCount[this.checkingIdx] = 0
    this.errorCount++
    $('p#error_count').text('Inkorrekte Antworten: ' + this.errorCount)


myTest = ''

articleShowHide = () ->
  console.log $('input:radio[name="word[speech_part]"]:checked').val()
  if $('input:radio[name="word[speech_part]"]:checked').val() == 'noun'
    $('div#article').show()
  else
    $('div#article').hide()

wordLoadTopics = () ->
  $.ajax
    url: '/topics.json'
    data:
      level_id: $('select#level_id option:selected').val()
    success: (data) ->
      $('#word_topic_id').empty()
      $.each data, (index,el) ->
        z = $('<option></option>')
        z.text el.name
        z.val el.id
        $('#word_topic_id').append(z)

jQuery ->
  if $('#form_id').length && ($('#form_id').val() == 'words_form')
    articleShowHide()
    wordLoadTopics()
    $('input:radio[name="word[speech_part]"]').change ->
      articleShowHide()
    $('select#level_id').change ->
      wordLoadTopics()
  if $('#page_id').length && ($('#page_id').val() == 'words_forward_test') 
    myTest = new WordsForwardTest()

