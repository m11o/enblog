import hljs from 'highlight.js/lib/core'

import ruby from 'highlight.js/lib/languages/ruby'
hljs.registerLanguage('ruby', ruby);

import haml from 'highlight.js/lib/languages/haml'
hljs.registerLanguage('haml', haml);

import go from 'highlight.js/lib/languages/go'
hljs.registerLanguage('go', go);

import python from 'highlight.js/lib/languages/python'
hljs.registerLanguage('python', python);

import bash from 'highlight.js/lib/languages/bash'
hljs.registerLanguage('bash', bash);

import javascript from 'highlight.js/lib/languages/javascript'
hljs.registerLanguage('javascript', javascript);

$(document).ready(() => {
  const $preDom = $('pre')
  if (!$preDom.length) return;

  $preDom.each((_index, block) => hljs.highlightBlock(block))
})
