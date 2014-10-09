# Load the application when DOM ready
$ ->

	class Todo extends Backbone.Model

		defaults: ->
			title: 'empty to do...'
			done: false
			order: Todos.nextOrder()

		# change done to false if true and to true if false
		toggle: ->
			@save done: not @get('done')

	# Collection of todos is saved in loacal storage
	class TodoList extends Backbone.Collection
		
		model: Todo

		localStorage: new Backbone.LocalStorage "todos-backbone"

		nextOrder: ->
			return 1 if not @length
			return @last().get('order') + 1


	class TodoView extends Backbone.View

		tagName: 'li'

		template: _.template( $('#item-template').html())

		events:
			"click .toggle":					"toggelDone"
			"keypress .edit": 				"updateOnEnter"
			"click span.destroy":			"removeItem"

		initialize: -> 
			@listenTo @model, 'change', @render
			@listenTo @model, 'destroy', @remove

		render: =>
			@$el.html( @template( @model.toJSON() ) );
			return this

		updateOnEnter: (e) ->
			console.log('enter pressed in Todo View')

		# removes item from collection and destroys
		removeItem: =>
			# it's not enought just to destroy the model
			# you have to listen to destroy on model and trigger remove action
			console.log this
			this.model.destroy()

		toggelDone: ->
			@model.toggle()


		close: ->


	class AppView extends Backbone.View
		el: $("#todoapp")	

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
			
		addOne: (todo) =>
			view = new TodoView({ model: todo })
			@$('#todo-list').append(view.render().el)

		addAll: =>
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

















