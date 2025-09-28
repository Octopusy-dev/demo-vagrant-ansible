import { Component, OnInit } from '@angular/core';
import { TodoService } from '../../services/todo.service';
import { TodoItem } from '../../models/todo-item.model';

@Component({
  selector: 'app-todo-list',
  template: `
    <div *ngIf="loading" class="loading-spinner">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Chargement...</span>
      </div>
    </div>

    <div *ngIf="error" class="alert alert-danger m-3" role="alert">
      <i class="fas fa-exclamation-triangle me-2"></i>
      {{ error }}
      <button class="btn btn-sm btn-outline-danger ms-2" (click)="loadTodos()">
        <i class="fas fa-retry me-1"></i>
        Réessayer
      </button>
    </div>

    <div *ngIf="!loading && !error && todos.length === 0" class="empty-state">
      <i class="fas fa-clipboard-list"></i>
      <h5>Aucune tâche</h5>
      <p class="text-muted">Commencez par ajouter votre première tâche !</p>
    </div>

    <div *ngIf="!loading && !error && todos.length > 0">
      <div class="list-group list-group-flush">
        <app-todo-item 
          *ngFor="let todo of todos; trackBy: trackByFn" 
          [todo]="todo"
          (todoUpdated)="onTodoUpdated($event)"
          (todoDeleted)="onTodoDeleted($event)"
          class="todo-item">
        </app-todo-item>
      </div>
      
      <div class="p-3 bg-light border-top">
        <small class="text-muted">
          <i class="fas fa-info-circle me-1"></i>
          {{ getTodoStats() }}
        </small>
      </div>
    </div>
  `,
  styles: [`
    .todo-item {
      display: block;
    }
  `]
})
export class TodoListComponent implements OnInit {
  todos: TodoItem[] = [];
  loading = false;
  error: string | null = null;

  constructor(private todoService: TodoService) {}

  ngOnInit() {
    this.loadTodos();
  }

  loadTodos() {
    this.loading = true;
    this.error = null;
    
    this.todoService.getTodos().subscribe({
      next: (todos) => {
        this.todos = todos;
        this.loading = false;
      },
      error: (error) => {
        this.error = error;
        this.loading = false;
      }
    });
  }

  onTodoUpdated(updatedTodo: TodoItem) {
    const index = this.todos.findIndex(todo => todo.id === updatedTodo.id);
    if (index !== -1) {
      this.todos[index] = updatedTodo;
    }
  }

  onTodoDeleted(deletedTodoId: number) {
    this.todos = this.todos.filter(todo => todo.id !== deletedTodoId);
  }

  trackByFn(index: number, item: TodoItem): number {
    return item.id || index;
  }

  getTodoStats(): string {
    const total = this.todos.length;
    const completed = this.todos.filter(todo => todo.isCompleted).length;
    const pending = total - completed;
    
    return `Total: ${total} | Terminées: ${completed} | En cours: ${pending}`;
  }
}