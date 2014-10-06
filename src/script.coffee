$ ->

	class Todo extends Backbone.Model

		defaults:
			title: 'empty to do...'
			done: false

		initialize: ->
			console.log @get('title')


	class TodoList extends Backbone.Collection
		
		model: Todo

		localStorage: new Backbone.LocalStorage "todos-backbone"


	class TodoView extends Backbone.View

		tagName: 'li'

		template: _.template $('#item-template').html()

		events:
			"keypress .edit": 		"updateOnEnter"

		initialize: => 
			@listenTo @model, 'change', @render
			console.log 'initializing TodoView'

		render: =>
			@$el.html( @template( @model.toJSON() ) );
			console.log 'rendering ...'
			return this

		updateOnEnter: (e) ->
			console.log('enter pressed')

		close: ->


	class AppView extends Backbone.View
		el: $('#todoapp')	

		events:
			"keypress #new-todo": 	"createOnEnter"

		initialize: =>
			# create class variable being jQ object
			@$input = @$('#new-todo');
			@$main = $('#main')
			@$footer = $('footer')
			@$todo_list = $('#todo-list')

			@listenTo Todos, 'all', @render
			@listenTo Todos, 'add', @addOne
			@listenTo Todos, 'reset', @addAll

			# reads all items in Todos collection
			# this triggers 'all' and @render
			Todos.fetch()

		render: ->
			if Todos.length
				@$main.show()
			else
				@$main.hide()
			
		@addOne: (todo) =>
			console.log 'adding One'
			view = new TodoView({ model: todo })
			$('#todo-list').append(view.render().el)

		@addAll: =>
			console.log 'adding All'
			Todos.each @addOne

		# works like charm
		createOnEnter: (e) ->
			# exit if not 'enter' pressed or input is empty
			return if e.keyCode isnt 13
			return if not @$input.val()

			# if not empty and enter pressed
			Todos.create title: @$input.val()

			# clear input
			@$input.val ''

	Todos = new TodoList
	App = new AppView

















