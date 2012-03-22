$(function(){
  function add_remove () {
    var el  = $(this);

    el.find('.add-remove-element:last')
      .after('<div class="add_remove_button_wrapper clearfix"><button type="button" class="add" title="Add row">Add new row</button><div>');

    var sample_data_button = el.find('a.sample_data');
    if (sample_data_button.length > 0) {
      el.find('.add_remove_button_wrapper:last').prepend(sample_data_button);
    }

    el.find('.add-remove-element > :last-child')
      .css('margin-right', '0')
      .after('<a href="#remove" class="remove" title="Remove">del</a>');

    el.find('.add').bind('click', add);
    el.find('.remove').bind('click', remove);

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

  function pulldown_click (e) {
    $(this).next().toggle('slide', {direction: 'up'});
  }


  // $('body').delegate('a[data-ajax="true"]', 'click.remote', remote_request);
  // $('body').delegate('form[data-ajax="true"]', 'submit.remote', remote_request);
  $('.add-remove').each(add_remove);
  $('a[data-type="pulldown"]').bind('click.pulldown', pulldown_click);
  $('#container .pulldown').hide();

  $('a.delete').live('click', function(event) {
      if ( confirm("Are you sure you want to delete this item?") )
          $('<form method="post" action="' + this.href.replace('/delete', '') + '" />')
              .append('<input type="hidden" name="_method" value="delete" />')
              .appendTo('body')
              .submit();

      return false;
  });


  function sample_data_click (e) {
    var el           = $(this);

    if (!el.data(data_content))
        return false;

    /* prevent too fast clicks */
    if (sample_data_click.active) {
      return false;
    }

    sample_data_click.active = true;
    var keys                 = new Array();
    var input                = next_free_input(el);

    if (!input)
      return sample_data_click.active = false;

    var data_content = 'key';

    if (!input)
      return sample_data_click.active = false;

    while (el.data(data_content)) {
      keys.push(el.data(data_content));
      el = el.parents('.ui-collapsible:first');
    }

    var value = keys.reverse();
    $(input)
      .val(value[value.length-1])
      .trigger('change');
    $(input)
      .parent()
      .next()
      .find('input')
      .val(value.join('.'))
      .trigger('change');
    $(this).remove();
    window.setTimeout(function(){
      sample_data_click.active = false;
    }, 500);

    /* search an empty input field. if not exist, add new one */
    function next_free_input (el) {
      var input   = $('input#' + el.data('input'));

      if (!input || input.length < 1)
        return null;

      var name    = input.attr('name');
      var wrapper = $(input).parents('.add-remove:first');

      input = wrapper.find('input[name="' + name + '"][value=""]:first');
      if (input.val() == '')
        return input;
      wrapper.find('button.add').click();

      input = wrapper.find('input[name="' + name + '"][value=""]:first');

      if (input.val() == '')
        return input;
      return false;
    }
  }
  $('#sample_data .tree a').live('click.sample_data', sample_data_click);
  $('#sample_data a.tablink').live('click.tablink', function(e) {
    e.preventDefault();
    e.stopPropagation();
    $('#sample_data .tree').hide();
    var selector = $(this).attr('href');
    $(selector).show();
  });


  $('input, select, textarea').each(function(){
      $(this).data('original_val', $(this).val());
    }).live('change', function(){
      if ($(this).val() != $(this).data('original_val')) {
        reload_code_preview();
        try {
          $("#button-save").button('enable');
        } catch (e) {}
        $('#button-execute, #button-delete').addClass('ui-disabled');
      } else {
        try {
          $("#button-save").button('disable');
        } catch (e) {}
        $('#button-execute, #button-delete').removeClass('ui-disabled');
      }
    });

    function reload_code_preview () {
      var form = $('form#builder_form');
      if (form.length < 1)
          return;

      var data = form.serialize();
      $.post(form.attr('action') + '/code', data, function(data) {
        $('#code_map').val(data);
      });
    }

    function save () {
        var form = $('form#builder_form');
        if (form.length < 1)
            return;

        var data = form.serialize();
        $.post(form.attr('action'), data, function(data) {
            rsss;
        });
    }
});