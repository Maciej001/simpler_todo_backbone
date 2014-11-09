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

		remove_todo: =>
			@destroy() 
			

	# Collection of todos is saved in local storage
	class TodoList extends Backbone.Collection
		
		model: Todo

		comparator: 'order'

		localStorage: new Backbone.LocalStorage "todos-backbone"

		# generates id number for each item
		nextOrder: ->
			return 1 if not @length
			return @last().get('order') + 1

		# Filters the collection
		doneItems: ->
			@where done: true

		remainingItems: ->
			@where done: false

	class TodoView extends Backbone.View

		tagName: 'li'

		template: _.template( $('#item-template').html())

		events:
			"click .toggle":					"toggelDone"
			"keypress .edit": 				"updateOnEnter"
			"click span.destroy":			"removeItem"
			"dblclick .view":					"edit"
			"blur .edit":							"close"

		initialize: -> 
			@listenTo @model, 'change', @render
			@listenTo @model, 'destroy', @remove

		render: =>
			@$el.html( @template( @model.toJSON() ) );
			@$input = @$('.edit')
			return this

		updateOnEnter: (e) =>
			@close if e.keyCode is 13

		# removes item from collection and destroys
		removeItem: =>
			# it's not enought just to destroy the model
			# you have to listen to destroy on model and trigger remove action
			this.model.destroy()

		toggelDone: ->
			@model.toggle()

		edit: ->
			@$el.addClass('editing')
			string_length = @$input.val().length
			@$input.focus()

			# select text inside input from 0 to string_length character meaning to the end 
			@$input[0].setSelectionRange(0, string_length)

		close: ->
			value = @$input.val()

			if not value
				@removeItem()
			else
				@model.save
					title: value
				@$el.removeClass('editing')


	class AppView extends Backbone.View
		el: $("#todoapp")	

		# template to display statistics at the bottom of the application
		statsTemplate: _.template( $("#stats-template").html() )

		events:
			"click .todo-clear": 		"clearCompleted"
			"click #toggle-all": 		"toggleAll"
			"keypress #new-todo": 	"createOnEnter"

		initialize: =>
			# create class variable being jQ object
			@$input = @$('#new-todo');
			@$main = $('#main')
			@$footer = $('footer')
			@$todo_list = $('#todo-list')
			@$allCheckbox = $('#toggle-all')[0]

			@listenTo Todos, 'all', @render
			@listenTo Todos, 'add', @addOne
			@listenTo Todos, 'reset', @addAll

			# reads all items in Todos collection
			# this triggers 'all' and @render
			Todos.fetch()

		render: ->
			done = Todos.doneItems().length
			remaining = Todos.remainingItems().length
			total = Todos.length

			if total
				@$main.show()
				@$footer.show()
				@$footer.html( @statsTemplate
						total: 			total
						remaining: 	remaining
						done: 			done
					)
			else
				@$main.hide()
				@$footer.hide()

		addOne: (todo) =>
			view = new TodoView({ model: todo })
			@$('#todo-list').append(view.render().el)

		addAll: =>
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

		clearCompleted: ->
			_.each(Todos.doneItems(), (todo) -> todo.remove_todo()) 
			return false

		toggleAll: ->
			done = @$allCheckbox.checked;
			Todos.each (todo) ->
				todo.save
					done: done


	Todos = new TodoList
	App = new AppView

















