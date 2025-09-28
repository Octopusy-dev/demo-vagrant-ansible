import { Component, Output, EventEmitter } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { TodoService } from '../../services/todo.service';
import { TodoItem } from '../../models/todo-item.model';

@Component({
  selector: 'app-todo-form',
  template: `
    <form [formGroup]="todoForm" (ngSubmit)="onSubmit()">
      <div class="mb-3">
        <label for="title" class="form-label">Titre *</label>
        <input 
          type="text" 
          class="form-control" 
          id="title"
          formControlName="title"
          placeholder="Entrez le titre de la tâche"
          [class.is-invalid]="titleControl?.invalid && titleControl?.touched">
        <div class="invalid-feedback" *ngIf="titleControl?.invalid && titleControl?.touched">
          <small *ngIf="titleControl?.errors?.['required']">Le titre est obligatoire.</small>
          <small *ngIf="titleControl?.errors?.['minlength']">Le titre doit contenir au moins 3 caractères.</small>
          <small *ngIf="titleControl?.errors?.['maxlength']">Le titre ne doit pas dépasser 200 caractères.</small>
        </div>
      </div>

      <div class="mb-3">
        <label for="description" class="form-label">Description</label>
        <textarea 
          class="form-control" 
          id="description"
          formControlName="description"
          rows="3"
          placeholder="Entrez une description (optionnelle)"
          [class.is-invalid]="descriptionControl?.invalid && descriptionControl?.touched"></textarea>
        <div class="invalid-feedback" *ngIf="descriptionControl?.invalid && descriptionControl?.touched">
          <small *ngIf="descriptionControl?.errors?.['maxlength']">La description ne doit pas dépasser 1000 caractères.</small>
        </div>
      </div>

      <div class="mb-3">
        <div class="form-check">
          <input 
            class="form-check-input" 
            type="checkbox" 
            id="isCompleted"
            formControlName="isCompleted">
          <label class="form-check-label" for="isCompleted">
            Marquer comme terminée
          </label>
        </div>
      </div>

      <div class="d-grid gap-2">
        <button 
          type="submit" 
          class="btn btn-primary"
          [disabled]="todoForm.invalid || isSubmitting">
          <span *ngIf="!isSubmitting">
            <i class="fas fa-plus me-2"></i>
            Ajouter la tâche
          </span>
          <span *ngIf="isSubmitting">
            <span class="spinner-border spinner-border-sm me-2" role="status"></span>
            Ajout en cours...
          </span>
        </button>
        
        <button 
          type="button" 
          class="btn btn-outline-secondary"
          (click)="resetForm()"
          [disabled]="isSubmitting">
          <i class="fas fa-eraser me-2"></i>
          Réinitialiser
        </button>
      </div>

      <div *ngIf="error" class="alert alert-danger mt-3" role="alert">
        <i class="fas fa-exclamation-triangle me-2"></i>
        {{ error }}
      </div>

      <div *ngIf="success" class="alert alert-success mt-3" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        {{ success }}
      </div>
    </form>
  `,
  styles: [`
    .form-control:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
    }
    
    .btn:disabled {
      cursor: not-allowed;
    }
  `]
})
export class TodoFormComponent {
  @Output() todoAdded = new EventEmitter<TodoItem>();

  todoForm: FormGroup;
  isSubmitting = false;
  error: string | null = null;
  success: string | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private todoService: TodoService
  ) {
    this.todoForm = this.formBuilder.group({
      title: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(200)]],
      description: ['', [Validators.maxLength(1000)]],
      isCompleted: [false]
    });
  }

  get titleControl() {
    return this.todoForm.get('title');
  }

  get descriptionControl() {
    return this.todoForm.get('description');
  }

  onSubmit() {
    if (this.todoForm.valid) {
      this.isSubmitting = true;
      this.error = null;
      this.success = null;

      const newTodo: TodoItem = {
        title: this.todoForm.value.title,
        description: this.todoForm.value.description || undefined,
        isCompleted: this.todoForm.value.isCompleted
      };

      this.todoService.createTodo(newTodo).subscribe({
        next: (createdTodo) => {
          this.success = 'Tâche ajoutée avec succès !';
          this.todoAdded.emit(createdTodo);
          this.resetForm();
          this.isSubmitting = false;
          
          // Effacer le message de succès après 3 secondes
          setTimeout(() => {
            this.success = null;
          }, 3000);
        },
        error: (error) => {
          this.error = 'Erreur lors de l\'ajout de la tâche: ' + error;
          this.isSubmitting = false;
        }
      });
    } else {
      // Marquer tous les champs comme touchés pour afficher les erreurs
      Object.keys(this.todoForm.controls).forEach(key => {
        this.todoForm.get(key)?.markAsTouched();
      });
    }
  }

  resetForm() {
    this.todoForm.reset({
      title: '',
      description: '',
      isCompleted: false
    });
    this.error = null;
    this.success = null;
    
    // Réinitialiser l'état des champs
    Object.keys(this.todoForm.controls).forEach(key => {
      this.todoForm.get(key)?.markAsUntouched();
    });
  }
}