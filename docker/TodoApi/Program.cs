using Microsoft.EntityFrameworkCore;
using TodoApi.Data;
using TodoApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Configuration de la base de données MySQL
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? "Server=mysql;Port=3306;Database=todoapi;Uid=root;Pwd=rootpassword;";

builder.Services.AddDbContext<TodoContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Ajouter CORS pour Angular
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAngular", policy =>
    {
        policy.WithOrigins("http://localhost:4200", "http://localhost:3000", "http://angular-app")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAngular");

app.UseAuthorization();

app.MapControllers();

// Endpoint de santé
app.MapGet("/", () => "Todo API with MySQL - Healthy!");
app.MapGet("/health", () => "OK");

// Initialiser la base de données
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<TodoContext>();
    try
    {
        // Attendre que MySQL soit prêt
        var maxRetries = 30;
        var retryCount = 0;
        
        while (retryCount < maxRetries)
        {
            try
            {
                Console.WriteLine($"Tentative de connexion à la base de données... ({retryCount + 1}/{maxRetries})");
                context.Database.CanConnect();
                break;
            }
            catch (Exception)
            {
                retryCount++;
                if (retryCount >= maxRetries)
                    throw;
                Thread.Sleep(2000); // Attendre 2 secondes
            }
        }
        
        // Supprimer et recréer la base de données si elle existe (pour le développement)
        context.Database.EnsureDeleted();
        context.Database.EnsureCreated();
        Console.WriteLine("Database created/verified successfully.");
        
        // Ajouter quelques données de test si la table est vide
        if (!context.TodoItems.Any())
        {
            context.TodoItems.AddRange(
                new TodoItem { Title = "Première tâche", Description = "Description de test", IsCompleted = false },
                new TodoItem { Title = "Deuxième tâche", Description = "Autre tâche de test", IsCompleted = true },
                new TodoItem { Title = "Troisième tâche", Description = "Encore une tâche", IsCompleted = false }
            );
            context.SaveChanges();
            Console.WriteLine("Test data added successfully.");
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Database initialization failed: {ex.Message}");
        // Ne pas crasher l'application, continuer sans base de données
    }
}

app.Run();