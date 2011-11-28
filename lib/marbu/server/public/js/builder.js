$(function(){
  function add_remove () {
    var el  = $(this);

    el.find('.add-remove-element:last')
      .after('<a href="#add" class="add" title="Add row">Add</a>');

    el.find('.add-remove-element > :last-child')
      .css('margin-right', '0')
      .after('<a href="#remove" class="remove" title="Remove">del</a>');

    el.find('a.add').bind('click', add);
    el.find('a.remove').bind('click', remove);

    show_or_hide_remove_button();

    function add (e) {
      e.preventDefault();
      var all       = $(this).parents('.add-remove:first');
      var my_clone  = $(all.find('.add-remove-element:last').clone(true));
      my_clone.find('input').val('');
      all.find('.add-remove-element:last').after(my_clone.hide());
      my_clone.show('fade', function(){$(this).find('input[type=text]:first').focus();});
      show_or_hide_remove_button();
    }

    function remove (e) {
      e.preventDefault();
      var me        = $(this).parents('.add-remove-element:first');
      var all       = me.parents('.add-remove:first');
      me.hide('fade', function(){$(this).remove(); show_or_hide_remove_button();});
    }

    function show_or_hide_remove_button () {
      if (el.find('.add-remove-element').length < 2)
        el.find('a.remove').hide();
      else
        el.find('a.remove').show();
    }
  }

  function remote_request (e) {
    e.preventDefault();

    var el        = $(this);
    var method    = el.attr('method') || el.attr('data-method') || 'GET';
    var url       = el.attr('action') || el.attr('href');
    var data_type = el.attr('data-type') || 'text';
    var data      = (el.is('form')) ? el.serializeArray():[];

    $.ajax({
        url:      url,
        data:     data,
        dataType: data_type,
        type:       method.toUpperCase(),
        beforeSend: function (xhr) {
          el.trigger('ajax:loading', xhr);
        },
        success: function (data, status, xhr) {
          el.trigger('ajax:success', [data, status, xhr]);
        },
        complete: function (element, xhr, statusText) {
          el.trigger('ajax:complete', [element, xhr, statusText]);
        },
        error: function (xhr, status, error) {
          el.trigger('ajax:failure', [xhr, status, error]);
        }
    });

  }


  $('body').delegate('a[data-remote="true"]', 'click.remote', remote_request);
  $('body').delegate('form[data-remote="true"]', 'submit.remote', remote_request);
  $('.add-remove').each(add_remove);
});