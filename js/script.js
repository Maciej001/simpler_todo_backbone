// Generated by CoffeeScript 1.8.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $(function() {
    var App, AppView, Todo, TodoList, TodoView, Todos;
    Todo = (function(_super) {
      __extends(Todo, _super);

      function Todo() {
        this.remove_todo = __bind(this.remove_todo, this);
        return Todo.__super__.constructor.apply(this, arguments);
      }

      Todo.prototype.defaults = function() {
        return {
          title: 'empty to do...',
          done: false,
          order: Todos.nextOrder()
        };
      };

      Todo.prototype.toggle = function() {
        return this.save({
          done: !this.get('done')
        });
      };

      Todo.prototype.remove_todo = function() {
        return this.destroy();
      };

      return Todo;

    })(Backbone.Model);
    TodoList = (function(_super) {
      __extends(TodoList, _super);

      function TodoList() {
        return TodoList.__super__.constructor.apply(this, arguments);
      }

      TodoList.prototype.model = Todo;

      TodoList.prototype.comparator = 'order';

      TodoList.prototype.localStorage = new Backbone.LocalStorage("todos-backbone");

      TodoList.prototype.nextOrder = function() {
        if (!this.length) {
          return 1;
        }
        return this.last().get('order') + 1;
      };

      TodoList.prototype.doneItems = function() {
        return this.where({
          done: true
        });
      };

      TodoList.prototype.remainingItems = function() {
        return this.where({
          done: false
        });
      };

      return TodoList;

    })(Backbone.Collection);
    TodoView = (function(_super) {
      __extends(TodoView, _super);

      function TodoView() {
        this.removeItem = __bind(this.removeItem, this);
        this.render = __bind(this.render, this);
        return TodoView.__super__.constructor.apply(this, arguments);
      }

      TodoView.prototype.tagName = 'li';

      TodoView.prototype.template = _.template($('#item-template').html());

      TodoView.prototype.events = {
        "click .toggle": "toggelDone",
        "keypress .edit": "updateOnEnter",
        "click span.destroy": "removeItem"
      };

      TodoView.prototype.initialize = function() {
        this.listenTo(this.model, 'change', this.render);
        return this.listenTo(this.model, 'destroy', this.remove);
      };

      TodoView.prototype.render = function() {
        this.$el.html(this.template(this.model.toJSON()));
        return this;
      };

      TodoView.prototype.updateOnEnter = function(e) {
        return console.log('enter pressed in Todo View');
      };

      TodoView.prototype.removeItem = function() {
        return this.model.destroy();
      };

      TodoView.prototype.toggelDone = function() {
        return this.model.toggle();
      };

      TodoView.prototype.close = function() {};

      return TodoView;

    })(Backbone.View);
    AppView = (function(_super) {
      __extends(AppView, _super);

      function AppView() {
        this.addAll = __bind(this.addAll, this);
        this.addOne = __bind(this.addOne, this);
        this.initialize = __bind(this.initialize, this);
        return AppView.__super__.constructor.apply(this, arguments);
      }

      AppView.prototype.el = $("#todoapp");

      AppView.prototype.statsTemplate = _.template($("#stats-template").html());

      AppView.prototype.events = {
        "click .todo-clear": "clearCompleted",
        "keypress #new-todo": "createOnEnter"
      };

      AppView.prototype.initialize = function() {
        this.$input = this.$('#new-todo');
        this.$main = $('#main');
        this.$footer = $('footer');
        this.$todo_list = $('#todo-list');
        this.listenTo(Todos, 'all', this.render);
        this.listenTo(Todos, 'add', this.addOne);
        this.listenTo(Todos, 'reset', this.addAll);
        return Todos.fetch();
      };

      AppView.prototype.render = function() {
        var done, remaining, total;
        done = Todos.doneItems().length;
        remaining = Todos.remainingItems().length;
        total = Todos.length;
        if (total) {
          this.$main.show();
          this.$footer.show();
          return this.$footer.html(this.statsTemplate({
            total: total,
            remaining: remaining,
            done: done
          }));
        } else {
          this.$main.hide();
          return this.$footer.hide();
        }
      };

      AppView.prototype.addOne = function(todo) {
        var view;
        view = new TodoView({
          model: todo
        });
        return this.$('#todo-list').append(view.render().el);
      };

      AppView.prototype.addAll = function() {
        return Todos.each(this.addOne);
      };

      AppView.prototype.createOnEnter = function(e) {
        if (e.keyCode !== 13) {
          return;
        }
        if (!this.$input.val()) {
          return;
        }
        Todos.create({
          title: this.$input.val()
        });
        return this.$input.val('');
      };

      AppView.prototype.clearCompleted = function() {
        _.each(Todos.doneItems(), function(todo) {
          return todo.remove_todo();
        });
        return false;
      };

      return AppView;

    })(Backbone.View);
    Todos = new TodoList;
    return App = new AppView;
  });

}).call(this);
