# Salary Project — Laravel 11 + Next 14 (Codespaces Ready)

**Stack :**
- PHP 8.2, Laravel 11, Jetstream (Livewire + Teams)
- MySQL 8
- Node.js 20, Next.js 14 (TypeScript, Tailwind, ESLint)
- GitHub Codespaces (Dev Containers)

## 🚀 Lancer en un clic (Codespaces)
Clique sur le bouton ci-dessous pour ouvrir ce projet **immigratio-allemagne** dans GitHub Codespaces et commencer à développer immédiatement :

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=webservicesebs-ctrl%2Fimmigratio-allemagne)

---

## ⚙️ Démarrage
Lorsque Codespaces s'ouvre, l'installation est automatique (PHP, Composer, Laravel, MySQL, Node, Next.js).
Dès que c'est fini :

**Terminal 1 – Backend Laravel**
```bash
cd salary-app
php artisan serve --host=0.0.0.0 --port=8000
```

**Terminal 2 – Frontend Next.js**
```bash
cd salary-frontend
npm run dev -- --host 0.0.0.0 --port=3000
```

Les ports 8000 (Laravel) et 3000 (Next) s’ouvrent automatiquement.

---

## 🗄️ Base de données (MySQL 8)
- Host: 127.0.0.1
- Port: 3306
- Database: `salary_db`
- Username: `root`
- Password: `root`

Ces valeurs sont déjà écrites dans `salary-app/.env` par le script.

---

## 📦 Structure
```text
.devcontainer/
  devcontainer.json
  setup.sh
salary-app/         (créé automatiquement à l'ouverture)
salary-frontend/    (créé automatiquement à l'ouverture)
```

---

## 🧰 Commandes utiles
```bash
# Réinitialiser la base et relancer les migrations
cd salary-app && php artisan migrate:fresh --seed

# Lancer des tests Laravel
php artisan test

# Lancer linter Next
cd ../salary-frontend && npm run lint
```
