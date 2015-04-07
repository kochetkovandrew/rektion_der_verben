setLanguage = () ->
  $.cookie('language', $('input:radio[name="language"]:checked').val(), {path: '/'})
  location.reload()

jQuery ->
  $('#words_training input[name="level_id"]').change ->
    $.ajax
      url: '/topics.json'
      data:
        level_id: $('#words_training input:radio[name="level_id"]:checked').val()
      success: (data) ->
        $('#topic_id').empty()
        $.each data, (index,el) ->
          z = $('<option></option>')
          z.text el.name
          z.val el.id
          $('#words_training #topic_id').append(z)
  $('#words_training select#topic_id').change ->
    $.ajax
      url: '/words/parts.json'
      data:
        topic_id: $('#words_training select#topic_id option:selected').val()
      success: (data) ->
        $.each data, (index,el) ->
          z = $('<option></option>')
          z.text t()['part'] + ' ' + el
          z.val el
          $('#words_training #part').append(z)
  if !$.cookie('language')
    $.cookie('language', 'de', {path: '/'})
  $('input[name="language"][value="' + $.cookie('language') + '"]').prop('checked', true)
  $('input[name="language"]').change ->
    setLanguage()
