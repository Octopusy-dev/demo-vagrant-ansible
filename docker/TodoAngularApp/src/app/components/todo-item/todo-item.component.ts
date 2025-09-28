import { Component, Input, Output, EventEmitter } from '@angular/core';
import { TodoService } from '../../services/todo.service';
import { TodoItem } from '../../models/todo-item.model';

@Component({
  selector: 'app-todo-item',
  template: `
    <div class="list-group-item list-group-item-action">
      <div class="d-flex justify-content-between align-items-start">
        <div class="flex-grow-1 me-3">
          <div class="d-flex align-items-center mb-2">
            <div class="form-check me-3">
              <input 
                class="form-check-input" 
                type="checkbox" 
                [checked]="todo.isCompleted"
                (change)="toggleStatus()"
                [disabled]="isUpdating">
            </div>
            <h6 class="mb-0" [class.completed-todo]="todo.isCompleted">
              {{ todo.title }}
            </h6>
          </div>
          
          <p 
            *ngIf="todo.description" 
            class="mb-2 text-muted small"
            [class.completed-todo]="todo.isCompleted">
            {{ todo.description }}
          </p>
          
          <div class="d-flex align-items-center text-muted small">
            <i class="fas fa-calendar-alt me-1"></i>
            <span class="me-3">{{ formatDate(todo.createdAt) }}</span>
            <span 
              *ngIf="todo.isCompleted" 
              class="badge bg-success">
              <i class="fas fa-check me-1"></i>
              Terminée
            </span>
            <span 
              *ngIf="!todo.isCompleted" 
              class="badge bg-warning text-dark">
              <i class="fas fa-clock me-1"></i>
              En cours
            </span>
          </div>
        </div>
        
        <div class="d-flex flex-column">
          <button 
            class="btn btn-sm btn-outline-danger mb-2"
            (click)="deleteTodo()"
            [disabled]="isDeleting"
            title="Supprimer">
            <i class="fas fa-trash" *ngIf="!isDeleting"></i>
            <span class="spinner-border spinner-border-sm" *ngIf="isDeleting"></span>
          </button>
        </div>
      </div>
      
      <!-- Loading overlay -->
      <div *ngIf="isUpdating" class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center bg-light bg-opacity-75">
        <div class="spinner-border spinner-border-sm text-primary" role="status">
          <span class="visually-hidden">Mise à jour...</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .list-group-item {
      position: relative;
      transition: all 0.2s ease;
    }
    
    .completed-todo {
      text-decoration: line-through;
      opacity: 0.7;
    }
    
    .form-check-input:checked {
      background-color: #198754;
      border-color: #198754;
    }
  `]
})
export class TodoItemComponent {
  @Input() todo!: TodoItem;
  @Output() todoUpdated = new EventEmitter<TodoItem>();
  @Output() todoDeleted = new EventEmitter<number>();

  isUpdating = false;
  isDeleting = false;

  constructor(private todoService: TodoService) {}

  toggleStatus() {
    this.isUpdating = true;
    
    this.todoService.toggleTodoStatus(this.todo).subscribe({
      next: () => {
        this.todo.isCompleted = !this.todo.isCompleted;
        this.todo.updatedAt = new Date().toISOString();
        this.todoUpdated.emit(this.todo);
        this.isUpdating = false;
      },
      error: (error) => {
        console.error('Erreur lors de la mise à jour:', error);
        this.isUpdating = false;
        // Optionnel: afficher un message d'erreur à l'utilisateur
      }
    });
  }

  deleteTodo() {
    if (!confirm('Êtes-vous sûr de vouloir supprimer cette tâche ?')) {
      return;
    }
    
    this.isDeleting = true;
    
    this.todoService.deleteTodo(this.todo.id!).subscribe({
      next: () => {
        this.todoDeleted.emit(this.todo.id!);
        this.isDeleting = false;
      },
      error: (error) => {
        console.error('Erreur lors de la suppression:', error);
        this.isDeleting = false;
        // Optionnel: afficher un message d'erreur à l'utilisateur
      }
    });
  }

  formatDate(dateString?: string): string {
    if (!dateString) return 'Non définie';
    
    try {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch {
      return 'Date invalide';
    }
  }
}