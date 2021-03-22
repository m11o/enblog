import Taggle from 'taggle'

$(document).ready(() => {
  if ($('#article-tag-form').length) {
    new Taggle('article-tag-form', {
      tags: [],
      hiddenInputName: 'article[tags_attributes][name][]'
    })
  }
});
