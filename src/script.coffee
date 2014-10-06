$ ->

	class Todo extends Backbone.Model

		defaults: ->
			title: 'empty to do...'
			done: false


	class TodoList extends Backbone.Collection

		model: Todo
		localStorage: new Backbone.LocalStorage "todos-backbone"

	class TodoView extends Backbone.View

		tagname: 'li'

		template: _.template $('#item-template').html()

		events:
			"keypress .edit": 		"updateOnEnter"

		initialize: -> 
			this.listenTo this.model, 'change', this.render

		render: ->
			this.$el.html(this.template(this.model.toJSON()));

		updateOnEnter: (e) ->
			console.log('enter pressed')

		close: ->

	class AppView extends Backbone.View

		el: $('#todoapp')	

		events:
			"keypress #new-todo": 	"createOnEnter"

		initialize: ->
			this.input = this.$('#new-todo');

		createOnEnter: (e) ->
			return if e.keyCode isnt 13
			return if isnt this.input.val()

			# if not empty and enter pressed
			Todos.create title: this.input.val()

			# clear input
			this.input.val ''

	Todos = new TodoList
	App = new AppView
