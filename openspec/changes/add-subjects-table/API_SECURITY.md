# API Security & Validation

## 📋 Resumo
Implementação de autenticação e validação em todos os endpoints da API de subjects.

## Autenticação (Tarefa 4.6)

### Estratégia
Todos os endpoints `/api/subject/*` requerem **autenticação do usuário**. A autenticação é feita verificando a sessão/token do usuário no contexto da requisição.

### Implementação em Xano

1. **Middleware de Autenticação**
   - Xano fornece autenticação nativa através da tabela `user`
   - Cada requisição autenticada inclui `user` no contexto
   - Verificar `if (!user || !user.id)` em cada endpoint
   - Retornar `401 Unauthorized` se não autenticado

2. **Código nos Endpoints**
   ```javascript
   // No início de cada função de endpoint
   if (!user || !user.id) {
     return {
       success: false,
       error: 'Unauthorized',
       status_code: 401
     };
   }
   ```

3. **Acesso ao ID do Usuário Autenticado**
   - Use `user.id` para obter ID do usuário autenticado
   - Comparar com `user_id` na tabela subject para verificar propriedade

### Endpoints Requerendo Autenticação
- POST `/api/subject` - ✓ Crear novo subject
- GET `/api/subject` - ✓ Listar subjects do usuário
- GET `/api/subject/:id` - ✓ Obter um subject específico
- PATCH `/api/subject/:id` - ✓ Atualizar subject
- DELETE `/api/subject/:id` - ✓ Deletar (soft delete) subject

---

## Validação (Tarefa 4.7)

### Request Validation

#### 1. POST /api/subject - Create Subject
**Campos Validados:**
- `name` (obrigatório)
  - Tipo: string
  - Comprimento: 1-255 caracteres
  - Erro: `"Subject name is required and must be 1-255 characters"` → 400
  
- `description` (opcional)
  - Tipo: string
  - Comprimento: máximo 2000 caracteres
  - Erro: `"Description must be 2000 characters or less"` → 400
  
- `subject_category` (opcional)
  - Tipo: string
  - Comprimento: máximo 100 caracteres
  - Erro: `"Category must be 100 characters or less"` → 400
  
- `academic_level` (opcional)
  - Tipo: enum
  - Valores válidos: `"elementary"`, `"middle_school"`, `"high_school"`, `"university"`
  - Erro: `"Academic level must be one of: ..."` → 400

#### 2. GET /api/subject - List Subjects
**Query Parameters Validados:**
- `category` (opcional) - filter by subject_category
- `level` (opcional) - filter by academic_level
- `page` (opcional, default: 1)
  - Tipo: integer
  - Valor: >= 1
  - Erro: `"Page must be >= 1"` → 400
  
- `page_size` (opcional, default: 20, máximo: 100)
  - Tipo: integer
  - Valor: 1-100
  - Erro: `"page_size must be between 1 and 100"` → 400

#### 3. GET /api/subject/:id - Get Subject
**URL Parameters Validados:**
- `id` (obrigatório)
  - Tipo: numeric integer
  - Erro se não é número: `"Subject ID must be numeric"` → 400
  - Erro se não encontra: `"Subject not found"` → 404

#### 4. PATCH /api/subject/:id - Update Subject
**Validações idênticas ao POST**, menos o campo `name` que agora é opcional
- Todos os campos são opcionais (partial update)
- Same validation rules apply when fields are provided

#### 5. DELETE /api/subject/:id - Delete Subject
**URL Parameters Validados:**
- `id` (obrigatório) - same as GET by id

---

### Response Validation

#### Standard Response Format (Todos os Endpoints)

**Success Response (2xx):**
```json
{
  "success": true,
  "data": {
    // resource data
  },
  "status_code": 200
}
```

**Error Response (4xx/5xx):**
```json
{
  "success": false,
  "error": "Error message",
  "status_code": 400
}
```

#### HTTP Status Codes

| Status | Scenario | Endpoint |
|--------|----------|----------|
| 201 | Subject created successfully | POST /api/subject |
| 200 | Successful GET, PATCH, DELETE | All GET/PATCH/DELETE |
| 400 | Validation error (invalid input) | All |
| 401 | Not authenticated | All |
| 403 | Access denied (not owner) | GET/:id, PATCH/:id, DELETE/:id |
| 404 | Resource not found | GET/:id, PATCH/:id, DELETE/:id |
| 410 | Subject already deleted | DELETE (on soft-deleted) |

---

## Checklist de Implementação

### Autenticação
- [ ] Every endpoint checks `if (!user || !user.id)` at start
- [ ] Returns `401 Unauthorized` when not authenticated
- [ ] Uses `user.id` to enforce subject ownership
- [ ] All 5 endpoints require authentication

### Validação de Request
- [ ] POST /api/subject validates name (required, 1-255 chars)
- [ ] POST /api/subject validates description (max 2000 chars)
- [ ] POST /api/subject validates category (max 100 chars)
- [ ] POST /api/subject validates academic_level (enum check)
- [ ] GET /api/subject validates page >= 1
- [ ] GET /api/subject validates page_size between 1-100
- [ ] GET/PATCH/DELETE validate numeric ID
- [ ] PATCH validates same fields as POST (when provided)
- [ ] All invalid inputs return 400 status

### Validação de Response
- [ ] All success responses include `success: true`
- [ ] All error responses include `success: false` and `error` message
- [ ] Correct HTTP status codes returned
- [ ] Consistent response format across all endpoints

### Access Control
- [ ] GET/:id returns 403 if subject doesn't belong to user
- [ ] PATCH/:id returns 403 if subject doesn't belong to user
- [ ] DELETE/:id returns 403 if subject doesn't belong to user
