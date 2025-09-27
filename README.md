# NestJS 2025 Tasks CRUD API

A simple NestJS 2025 project demonstrating **Tasks CRUD REST API**.

---

## 1. Prerequisites

Before starting, make sure you have:

- Node.js >= 20
- npm
- Git (optional)

Check Node.js version:

```bash
node -v
```

---

## 2. Install NestJS CLI

```bash
npm install -g @nestjs/cli
```

Verify installation:

```bash
nest -v
```

---

## 3. Create a New NestJS Project

```bash
nest new nest-crud-demo
cd nest-crud-demo
```

During project creation, select your preferred package manager (`npm` or `yarn`).  

Run the project:

```bash
npm run start:dev
```

Visit [http://localhost:3000](http://localhost:3000) — you should see `Hello World!`.

---

## 4. Create a Resource (Tasks)

Generate a resource:

```bash
nest g resource tasks --no-spec
```

> Note: `--crud` is no longer available. CRUD logic must be implemented manually.

This will create the following **directory structure**:

```
src/
 └── tasks/
      ├── dto/
      │    ├── create-task.dto.ts
      │    └── update-task.dto.ts
      ├── tasks.controller.ts
      ├── tasks.service.ts
      └── tasks.module.ts
```

### Directory explanation

- `dto/` → Data Transfer Objects (for request validation)  
- `tasks.controller.ts` → Handles HTTP requests (GET/POST/PATCH/DELETE)  
- `tasks.service.ts` → Contains business logic  
- `tasks.module.ts` → Connects controller and service  

---

## 5. REST API Endpoints

| Method | Endpoint      | Body / Params                                      | Description       |
|--------|---------------|---------------------------------------------------|-----------------|
| GET    | /tasks        | –                                                 | Get all tasks    |
| GET    | /tasks/:id    | id (path param)                                   | Get a single task|
| POST   | /tasks        | { "title": "task title", "description": "desc" } | Create a new task|
| PATCH  | /tasks/:id    | { "title": "...", "description": "...", "completed": true/false } | Update task     |
| DELETE | /tasks/:id    | id (path param)                                   | Delete task      |

---

## 6. Example curl Commands

**Create Task**

```bash
curl -X POST http://localhost:3000/tasks \
-H "Content-Type: application/json" \
-d '{"title":"Buy milk","description":"2 liters"}'
```

**Get All Tasks**

```bash
curl http://localhost:3000/tasks
```

**Get One Task**

```bash
curl http://localhost:3000/tasks/1
```

**Update Task**

```bash
curl -X PATCH http://localhost:3000/tasks/1 \
-H "Content-Type: application/json" \
-d '{"completed":true}'
```

**Delete Task**

```bash
curl -X DELETE http://localhost:3000/tasks/1
```

---

## 7. Notes

- This example uses **in-memory storage** — all data will be lost on server restart.  
- For production, use a database (TypeORM, Prisma, etc.).  
- Avoid running `npm run start:dev` with sudo to prevent permission errors.  

