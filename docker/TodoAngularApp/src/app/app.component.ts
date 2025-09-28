import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
    <div class="container-fluid">
      <div class="todo-container">
        <div class="todo-header">
          <h1 class="display-4 mb-4">
            <i class="fas fa-tasks text-primary me-3"></i>
            Todo App Angular
          </h1>
          <p class="lead text-muted">
            Gérez vos tâches avec cette application connectée à l'API .NET
          </p>
        </div>
        
        <div class="row">
          <div class="col-lg-4 mb-4">
            <div class="card todo-card">
              <div class="card-header">
                <h5 class="card-title mb-0">
                  <i class="fas fa-plus-circle text-success me-2"></i>
                  Nouvelle tâche
                </h5>
              </div>
              <div class="card-body">
                <app-todo-form (todoAdded)="onTodoAdded()"></app-todo-form>
              </div>
            </div>
          </div>
          
          <div class="col-lg-8">
            <div class="card todo-card">
              <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">
                  <i class="fas fa-list text-info me-2"></i>
                  Liste des tâches
                </h5>
                <button 
                  class="btn btn-outline-secondary btn-sm" 
                  (click)="refreshTodos()"
                  title="Actualiser">
                  <i class="fas fa-sync-alt"></i>
                </button>
              </div>
              <div class="card-body p-0">
                <app-todo-list #todoList></app-todo-list>
              </div>
            </div>
          </div>
        </div>
        
        <footer class="text-center mt-5 pt-4 border-top text-muted">
          <small>
            <i class="fas fa-code me-1"></i>
            Todo App - Angular + .NET API + MySQL + Docker
          </small>
        </footer>
      </div>
    </div>
  `,
  styles: []
})
export class AppComponent {
  
  onTodoAdded() {
    // Rafraîchir la liste des todos après ajout
    this.refreshTodos();
  }
  
  refreshTodos() {
    // Cette méthode sera appelée pour rafraîchir la liste
    // Elle sera implémentée via ViewChild si nécessaire
    window.location.reload();
  }
}