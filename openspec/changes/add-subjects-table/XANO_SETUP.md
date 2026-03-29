# Setup da Tabela Subject no Xano

## 📋 Resumo
Criar a tabela `subject` no banco de dados Xano com os campos necessários para gerenciar disciplinas acadêmicas.

## 🛠️ Instruções para Criar a Tabela no Xano UI

### Passo 1: Acessar o Editor de Tabelas
1. Acesse a interface do Xano
2. Navegue para **Database** → **Tables**
3. Clique em **Create new table**

### Passo 2: Configurar Informações Básicas
- **Table Name:** `subject`
- **Display Name:** Subject
- **Description:** Academic disciplines/subjects managed by users

### Passo 3: Criar os Campos
Adicione os campos na seguinte ordem:

#### Campo 1: ID (Primary Key)
- **Field Name:** `id`
- **Field Type:** Auto-Increment (Primary Key)
- **Required:** Yes
- **Description:** Unique identifier for each subject

#### Campo 2: User ID (Foreign Key)
- **Field Name:** `user_id`
- **Field Type:** Foreign Table Record
- **Table Reference:** `user` (select from existing tables)
- **Required:** Yes
- **Description:** Foreign key reference to the user who owns this subject
- **Display:** User name or email

#### Campo 3: Name
- **Field Name:** `name`
- **Field Type:** Text Input
- **Required:** Yes
- **Max Length:** 255
- **Description:** Name/title of the academic subject
- **Input Validation:** Non-empty, max 255 characters

#### Campo 4: Description
- **Field Name:** `description`
- **Field Type:** Long Text
- **Required:** No
- **Max Length:** 2000
- **Description:** Detailed description of the subject

#### Campo 5: Subject Category
- **Field Name:** `subject_category`
- **Field Type:** Text Input
- **Required:** No
- **Max Length:** 100
- **Description:** Academic category (e.g., Mathematics, Literature, Sciences)

#### Campo 6: Academic Level
- **Field Name:** `academic_level`
- **Field Type:** Text / Enum
- **Required:** No
- **Suggested Values:** elementary, middle_school, high_school, university
- **Description:** Academic level/grade the subject is for

#### Campo 7: Is Active
- **Field Name:** `is_active`
- **Field Type:** Boolean
- **Required:** Yes
- **Default Value:** true
- **Description:** Whether the subject is active (false = soft deleted)

#### Campo 8: Created At
- **Field Name:** `created_at`
- **Field Type:** Date & Time
- **Required:** Yes
- **Auto-populate:** Yes (set current timestamp on create)
- **Description:** When the subject was created

#### Campo 9: Updated At
- **Field Name:** `updated_at`
- **Field Type:** Date & Time
- **Required:** Yes
- **Auto-populate:** Yes (set current timestamp on create/update)
- **Description:** When the subject was last updated

### Passo 4: Salvar a Tabela
- Clique em **Save** ou **Create Table**
- Verifique se todos os 9 campos foram criados com sucesso

### Passo 5: Verificar Estrutura
- Acesse **Database** → **Tables** → **subject**
- Confirme que todos os campos estão listados:
  - ✓ id (primary key)
  - ✓ user_id (foreign key)
  - ✓ name (required, text)
  - ✓ description (optional, text)
  - ✓ subject_category (optional, text)
  - ✓ academic_level (optional, text)
  - ✓ is_active (boolean, default true)
  - ✓ created_at (timestamp)
  - ✓ updated_at (timestamp)

---

## 📝 Propriedades da Tabela - Resumo

| Field | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| id | Auto-Increment | Yes | - | Primary Key |
| user_id | Foreign Key (user) | Yes | - | Enforces ownership |
| name | Text (max 255) | Yes | - | Subject name |
| description | Long Text | No | - | Optional description |
| subject_category | Text (max 100) | No | - | E.g., Mathematics |
| academic_level | Text | No | - | elementary/high_school/university |
| is_active | Boolean | Yes | true | Soft delete flag |
| created_at | Timestamp | Yes | NOW() | Auto-set on create |
| updated_at | Timestamp | Yes | NOW() | Auto-set on create/update |

---

## ✅ Checklist de Verificação

- [ ] Tabela `subject` criada
- [ ] Campo `user_id` aponta corretamente para tabela `user`
- [ ] Campo `created_at` auto-popula com timestamp current
- [ ] Campo `updated_at` auto-popula com timestamp current
- [ ] Campo `is_active` padrão é `true`
- [ ] Todos os 9 campos estão presentes
- [ ] Nenhum erro de validação nos campos obrigatórios
