###global define###

define ['directives/directives'],
(directives) ->
	'use strict'

	linker = (scope, element, attrs) ->
		if attrs.class?
			element.addClass attrs.class
		if attrs.type?
			attrs.type.trim().split(/\s+/).forEach (cls) ->
				element.addClass "btn-#{cls}"

	directives.directive 'btn', [->
		restrict: 'E'
		template: "<button class='btn' ng-transclude></button>"
		transclude: true
		replace: true
		link: linker
	]

	directives.directive 'abtn', [->
		restrict: 'E'
		template: "<a class='btn' ng-transclude></a>"
		transclude: true
		replace: true
		link: linker
	]

	# directives.directive 'btn', [->
	# 	restrict: 'E'
	# 	compile: (element, attrs) ->
	# 		buttonType = if attrs.btn? then 'button' else 'link'
	# 		switch buttonType
	# 			when 'button' then button = $("<button class='btn'>#{element.html()}</button>")
	# 			when 'link'   then button = $("<a class='btn'>#{element.html()}</a>")

	# 		element.replaceWith(button)

	# 		if attrs.type?
	# 			attrs.type.trim().split(/\s+/).forEach (cls) ->
	# 				button.addClass("btn-#{cls}")
	# ]
