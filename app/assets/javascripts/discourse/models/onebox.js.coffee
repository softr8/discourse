Discourse.Onebox = (->
  # for now it only stores in a var, in future we can change it so it uses localStorage,
  #  trouble with localStorage is that expire semantics need some thinking

  #cacheKey = "__onebox__"
  localCache = {}

  cache = (url, contents) ->
    localCache[url] = contents

    #if localStorage && localStorage.setItem
    #  localStorage.setItme
    null

  lookupCache = (url) ->
    localCache[url]

  lookup = (url, refresh, callback) ->
    cached = lookupCache(url) unless refresh
    if cached
      callback(cached)
      return false
    else
      $.get "/onebox", url: url, refresh: refresh, (html) ->
        cache(url,html)
        callback(html)
      return true

  load = (e, refresh=false) ->

    url = e.href
    $elem = $(e)
    return if $elem.data('onebox-loaded')

    loading = lookup url, refresh, (html) ->
      $elem.removeClass('loading-onebox')
      $elem.data('onebox-loaded')
      return unless html
      return unless html.trim().length > 0
      $elem.replaceWith(html)

    $elem.addClass('loading-onebox') if loading

  load: load
  lookup: lookup
  lookupCache: lookupCache
)()

