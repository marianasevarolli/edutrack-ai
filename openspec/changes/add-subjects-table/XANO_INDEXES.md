# Criação de Índices na Tabela Subject

## 📋 Resumo
Criar índices para otimizar as queries mais comuns na tabela `subject`.

## Índices a Criar

### Índice 1: user_id
**Propósito:** Acelerar queries "obter todos os subjects de um usuário"

**Procedimento no Xano UI:**
1. Vá para **Database** → **Tables** → **subject**
2. Acesse a aba **Indexes**
3. Clique em **Create Index**
4. **Index Name:** `idx_user_id`
5. **Columns:** Select `user_id`
6. **Type:** Standard Index
7. Clique **Save**

---

### Índice 2: created_at
**Propósito:** Suportar sorting e paginação por data de criação

**Procedimento no Xano UI:**
1. Vá para **Database** → **Tables** → **subject**
2. Acesse a aba **Indexes**
3. Clique em **Create Index**
4. **Index Name:** `idx_created_at`
5. **Columns:** Select `created_at`
6. **Type:** Standard Index
7. **Sort Order:** Descending (para queries recentes primeiro)
8. Clique **Save**

---

### Índice 3: Composite (user_id + is_active)
**Propósito:** Otimizar queries com filtro "obter subjects ativos de um usuário"

**Procedimento no Xano UI:**
1. Vá para **Database** → **Tables** → **subject**
2. Acesse a aba **Indexes**
3. Clique em **Create Index**
4. **Index Name:** `idx_user_active`
5. **Columns:** Select `user_id` e depois `is_active` (nessa ordem)
6. **Type:** Composite Index
7. Clique **Save**

---

## Query Performance Testing

Após criar os índices, teste o desempenho com:

```sql
-- Query 1: Get all subjects for user (should use idx_user_id)
SELECT * FROM subject WHERE user_id = [user_id] ORDER BY created_at DESC

-- Query 2: Get active subjects for user (should use idx_user_active)
SELECT * FROM subject WHERE user_id = [user_id] AND is_active = true ORDER BY created_at DESC

-- Query 3: Get subjects created after date (should use idx_created_at)
SELECT * FROM subject WHERE created_at > [date] ORDER BY created_at DESC
```

---

## ✅ Checklist de Verificação

- [ ] Índice `idx_user_id` criado na coluna `user_id`
- [ ] Índice `idx_created_at` criado na coluna `created_at` (descending)
- [ ] Índice composto `idx_user_active` criado em `(user_id, is_active)`
- [ ] Todos os 3 índices aparecem na aba **Indexes** da tabela
- [ ] Nenhum erro ao criar os índices
- [ ] Queries executadas com sucesso (sem erros de validação)
