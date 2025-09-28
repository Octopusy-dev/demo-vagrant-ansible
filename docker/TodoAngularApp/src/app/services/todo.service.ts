import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { TodoItem } from '../models/todo-item.model';

@Injectable({
  providedIn: 'root'
})
export class TodoService {
  private apiUrl = 'http://localhost:5000/api/todos';

  constructor(private http: HttpClient) {}

  // Récupérer toutes les tâches
  getTodos(): Observable<TodoItem[]> {
    return this.http.get<TodoItem[]>(this.apiUrl)
      .pipe(catchError(this.handleError));
  }

  // Récupérer une tâche par ID
  getTodo(id: number): Observable<TodoItem> {
    return this.http.get<TodoItem>(`${this.apiUrl}/${id}`)
      .pipe(catchError(this.handleError));
  }

  // Créer une nouvelle tâche
  createTodo(todo: TodoItem): Observable<TodoItem> {
    return this.http.post<TodoItem>(this.apiUrl, todo)
      .pipe(catchError(this.handleError));
  }

  // Mettre à jour une tâche
  updateTodo(id: number, todo: TodoItem): Observable<void> {
    return this.http.put<void>(`${this.apiUrl}/${id}`, todo)
      .pipe(catchError(this.handleError));
  }

  // Supprimer une tâche
  deleteTodo(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`)
      .pipe(catchError(this.handleError));
  }

  // Basculer le statut d'une tâche (complétée/non complétée)
  toggleTodoStatus(todo: TodoItem): Observable<void> {
    const updatedTodo = { ...todo, isCompleted: !todo.isCompleted };
    return this.updateTodo(todo.id!, updatedTodo);
  }

  // Gestion des erreurs
  private handleError(error: HttpErrorResponse): Observable<never> {
    let errorMessage = 'Une erreur est survenue';
    
    if (error.error instanceof ErrorEvent) {
      // Erreur côté client
      errorMessage = `Erreur: ${error.error.message}`;
    } else {
      // Erreur côté serveur
      errorMessage = `Code d'erreur: ${error.status}, Message: ${error.message}`;
    }
    
    console.error(errorMessage);
    return throwError(() => errorMessage);
  }
}