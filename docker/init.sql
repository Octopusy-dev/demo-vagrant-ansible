-- Script d'initialisation pour la base de données todoapi
USE todoapi;

-- Créer un utilisateur pour l'API (optionnel, déjà fait via variables d'environnement)
-- CREATE USER IF NOT EXISTS 'apiuser'@'%' IDENTIFIED BY 'apipassword';
-- GRANT ALL PRIVILEGES ON todoapi.* TO 'apiuser'@'%';
-- FLUSH PRIVILEGES;

-- Insérer quelques données de test (optionnel)
-- La table sera créée automatiquement par Entity Framework
-- INSERT INTO TodoItems (Title, Description, IsCompleted, CreatedAt) VALUES 
-- ('Première tâche', 'Description de la première tâche', false, NOW()),
-- ('Deuxième tâche', 'Description de la deuxième tâche', true, NOW()),
-- ('Troisième tâche', 'Description de la troisième tâche', false, NOW());

SELECT 'Base de données todoapi initialisée avec succès!' as Message;