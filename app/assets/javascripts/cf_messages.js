/* -*- coding: utf-8 -*- */
/* global cforum, t, Dropzone */

cforum.cf_messages = {
  initMarkdown: function(elem_id) {
    var elem = $("#" + elem_id);

    if(elem.length) {
      cforum.markdown_buttons.l10n();

      elem.markdown({autofocus: false, savable: false, iconlibrary: 'fa',
                     language: 'de', hiddenButtons: 'cmdPreview',
                     disabledButtons: 'cmdPreview', resize: 'both',
                     additionalButtons: [
                       {
                         name: 'groupCustom',
                         data: [
                           cforum.markdown_buttons.noMarkdown,
                           cforum.markdown_buttons.tab,
                           cforum.markdown_buttons.hellip,
                           cforum.markdown_buttons.mdash,
                           cforum.markdown_buttons.almostEqualTo,
                           cforum.markdown_buttons.unequal,
                           cforum.markdown_buttons.times,
                           cforum.markdown_buttons.arrowRight,
                           cforum.markdown_buttons.arrowUp,
                           cforum.markdown_buttons.blackUpPointingTriangle,
                           cforum.markdown_buttons.rightwardsDoubleArrow,
                           cforum.markdown_buttons.trademark,
                           cforum.markdown_buttons.doublePunctuationMarks,
                           cforum.markdown_buttons.singlePunctuationMarks
                         ]
                       }
                     ]});
    }
  },

  maxLen: function(text) {
    return text.length > 100;
  },

  initQuotes: function() {
    if(!cforum.currentUser || cforum.currentUser.settings.options.fold_quotes != 'yes') {
      return;
    }

    $(".posting-content blockquote").each(function() {
      var $this = $(this);

      if(cforum.cf_messages.maxLen($this.text())) {
        $this.css('display', 'none');
        $this.before('<blockquote class="show-quotes">' + t('unfold_quote') + '</blockquote>');
      }
    });

    $(".posting-content").click(function(ev) {
      var trg = $(ev.target);
      if(trg.hasClass('show-quotes')) {
        trg.next().fadeIn('fast');
        trg.remove();
      }
    });
  },

  init: function() {
    var action = $('body').attr('data-action');
    cforum.tags.initTags();
    cforum.cf_messages.initQuotes();

    if(action != 'create' && action != 'update') {
      cforum.cf_messages.initCursor();
    }

    cforum.cf_messages.initMarkdown("message_input");
    cforum.cf_messages.initUpload();
  },

  new: function() {
    if(cforum.cf_messages.quotedMessage) {
      $(".form-actions").append("<button class=\"cf-btn quote-message\">" + t('add_quote') + "</button>");
      $('.form-actions .quote-message').on('click', cforum.cf_messages.quoteMessage);
    }
  },

  quoteMessage: function(ev) {
    ev.preventDefault();
    $("#message_input").val($("#message_input").val() + cforum.cf_messages.quotedMessage);
    $(".form-actions .quote-message").fadeOut('fast', function() { $(this).remove(); });
  },

  initCursor: function() {
    var content = $("#message_input");
    var subj = $("#cf_message_subject");
    var author = $("#cf_message_author");

    cforum.cf_threads.setCursor(author, subj, content);
  },

  initUpload: function() {
    if($("#message_input").length > 0 && window.Dropzone) {
      $("#message_input").after('<div class="image-upload">Bilder hierher ziehen oder klicken, um sie hochzuladen</div>');
      $(".image-upload").dropzone({
        createImageThumbnails: false,
        maxFilesize: 2, // 2mb max filesize
        url: cforum.baseUrl + 'images.json',
        clickable: true,
        acceptedFiles: 'image/*',
        previewTemplate : '<div style="display:none"></div>',
        fallback: function() { },
        init: function() {
          this.on("success", function(file, rsp) {
            var $msg = $("#message_input");
            var selection = $msg.getSelection();
            var md = '![Alternativ-Text](' + cforum.basePath + 'images/' + rsp.path + ')';

            $msg.replaceSelection(md);

            window.setTimeout(function() {
              $msg.focus();
              $msg.setSelection(selection.start + 2, selection.start + 17);
            }, 0);
          });

          this.on('error', function(file, response) {
            cforum.alert.error(response.error || t('internal_error'));
          });

          this.on('sending', function(file, xhr, formData) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
          });
        }
      });
    }
  }
};

/* eof */
