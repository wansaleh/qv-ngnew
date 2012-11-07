define ['libs/angular', 'directives/directives'],
(angular, directives) ->
  'use strict'

  directives.directive "qvView", ($http, $templateCache, $route, $anchorScroll, $compile, $controller) ->
    restrict: "ECA"
    terminal: true
    link: (scope, parentElm, attr) ->

      # Create just an element for a partial
      createPartial = (template) ->
        # Create it this way because some templates give error
        # when you just do angular.element(template) (unknown reason)
        d = document.createElement("div")
        d.innerHTML = template
        element: angular.element(d.children[0])

        # Store a reference to controller, but don'r create it yet
        controller: $route.current and $route.current.controller
        locals: $route.current and $route.current.locals

      # 'Angularize' a partial: Create scope/controller, $compile element, insert into dom
      setupPartial = (partial) ->
        cur = $route.current
        partial.scope = cur.locals.$scope = scope.$new()

        # partial.controller contains a reference to the
        # controller constructor at first
        # Now we actually instantiate it
        if partial.controller
          partial.controller = $controller(partial.controller, partial.locals)
          partial.element.contents().data "$ngControllerController", partial.controller
          $compile(partial.element.contents()) partial.scope
        parentElm.append partial.element
        partial.scope.$emit "$viewContentLoaded"

      destroyPartial = (partial) ->
        partial.scope.$destroy()
        partial.element.remove()
        partial = null

      # Transition end stuff from bootstrap:
      # http://twitter.github.com/bootstrap/assets/js/bootstrap-transition.js
      onTransitionEnd = (el, callback) ->
        i = 0
        while i < transEndEvents.length
          el[0].addEventListener transEndEvents[i], callback
          i++

      transition = (inPartial, outPartial) ->
        # Do a timeout so the initial class for the
        # element has time to 'take effect'
        setTimeout ->
          inPartial.element.addClass inClass
          onTransitionEnd inPartial.element, updatePartialQueue
          if outPartial
            outPartial.element.addClass outClass
            onTransitionEnd outPartial.element, ->
              destroyPartial outPartial

      updatePartialQueue = ->
        # Bring in a new partial if it exists
        if partials.length > 0
          newPartial = partials.pop()
          setupPartial newPartial
          transition newPartial, currentPartial
          currentPartial = newPartial

      update = ->
        if $route.current and $route.current.locals.$template
          partials.unshift createPartial($route.current.locals.$template)
          updatePartialQueue()

      partials = []
      inClass = attr.inClass
      outClass = attr.outClass
      currentPartial = undefined
      lastPartial = undefined
      scope.$on "$routeChangeSuccess", update
      update()
      transEndEvents = ["webkitTransitionEnd", "transitionend", "oTransitionEnd", "otransitionend", "transitionend"]
