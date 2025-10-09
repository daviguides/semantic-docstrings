# Prompt: Validar e Aplicar Documentação Semântica (Princípio 6)

## 🎯 Objetivo

Este prompt instrui um LLM a validar e aplicar o **Princípio 6: Documentação como Camada Semântica** em todos os arquivos Python de um projeto, garantindo que docstrings expliquem **POR QUÊ** e **CONTEXTO**, não apenas **O QUÊ**.

---

## 📝 Como Usar Este Prompt

**Copie e cole o texto abaixo para o LLM:**

```
Você deve validar e aplicar o Princípio "DOCUMENTATION AS A SEMANTIC LAYER"
conforme definido em @/.project/docs/refact/semantic_docstrings.md

Execute as seguintes etapas em ordem:

---

## ETAPA 1: ANÁLISE E IDENTIFICAÇÃO

Analise TODOS os arquivos Python do projeto (use `glob **/*.py`) e categorize:

### Categoria A: ✅ Arquivos que JÁ seguem o princípio
Critérios para aprovação:
- ✅ Possui docstring de módulo com Architecture/Responsibility/Should/Boundaries
- ✅ Funções/classes têm Responsibility e Semantic Context
- ✅ Args explicam contexto (não apenas tipo)
- ✅ Returns explicam significado (não apenas tipo)
- ✅ Docstrings estão atualizadas com o código atual

### Categoria B: ⚠️ Arquivos que precisam de AJUSTES
Critérios de identificação:
- ⚠️ Tem docstrings mas são genéricas/superficiais
- ⚠️ Falta Architecture/Responsibility no módulo
- ⚠️ Falta Semantic Context nas funções
- ⚠️ Docstrings desatualizadas (parâmetros mudaram)

### Categoria C: ❌ Arquivos SEM documentação semântica
Critérios de identificação:
- ❌ Sem docstring de módulo
- ❌ Funções sem docstrings
- ❌ Docstrings que apenas repetem a sintaxe

---

## ETAPA 2: RELATÓRIO DE ANÁLISE

Gere um relatório estruturado:

```markdown
## 📊 RELATÓRIO DE DOCUMENTAÇÃO SEMÂNTICA

### ✅ CATEGORIA A: Conforme (X arquivos)
- app/workflow.py
- app/agents/negotiation_agent.py
- ...

### ⚠️ CATEGORIA B: Precisa Ajustes (Y arquivos)
#### app/domain/models.py
**Problemas identificados:**
- [ ] Sem docstring de módulo
- [ ] Função `parse_agent_response`: docstring genérica, falta Semantic Context
- [ ] Função `apply_business_rules`: parâmetro `user_text` não explicado

**Sugestões de melhoria:**
- Adicionar docstring de módulo explicando papel no domínio
- Explicar POR QUÊ parse_agent_response existe
- Explicar contexto de onde vem user_text

#### app/infrastructure/storage.py
**Problemas identificados:**
- [ ] Sem docstring de módulo
- [ ] Funções `get_memory` e `get_storage` sem Responsibility
...

### ❌ CATEGORIA C: Sem Documentação (Z arquivos)
- app/api/routes/trigger.py
- ...
```

---

## ETAPA 3: VALIDAÇÃO DE ATUALIZAÇÃO

Para cada arquivo da Categoria B e C, verifique:

### Checklist de Atualização:
```python
# Para cada função/classe, valide:
1. [ ] Assinatura da função corresponde aos Args descritos?
2. [ ] Type hints correspondem aos tipos na docstring?
3. [ ] Comportamento descrito corresponde à implementação?
4. [ ] Exceções descritas correspondem ao código?
5. [ ] Exemplos (se houver) ainda funcionam?
```

**Se encontrar desatualização:**
- Marque no relatório como "⚠️ DESATUALIZADO"
- Liste especificamente o que mudou

---

## ETAPA 4: APLICAÇÃO DE CORREÇÕES

Aplique o template do Princípio para cada arquivo conforme:

`/.project/docs/refact/semantic_docstrings.md`

---

## ETAPA 5: GARANTIAS DE QUALIDADE

Antes de finalizar, valide:

### ✅ Checklist de Qualidade:
```
CAMADA SEMÂNTICA:
- [ ] Docstrings explicam POR QUÊ, não apenas O QUÊ
- [ ] Args/Returns têm CONTEXTO e SIGNIFICADO
- [ ] Exceções têm INTENÇÃO clara
- [ ] One-word keys usadas consistentemente

FRONTEIRAS ARQUITETURAIS:
- [ ] "Should:" está claro e específico
- [ ] "Boundaries:" define limites e delegações
- [ ] "Entry:" lista interface pública completa

ATUALIZAÇÃO:
- [ ] Parâmetros correspondem à assinatura
- [ ] Type hints correspondem à descrição
- [ ] Comportamento descrito corresponde ao código

CONSISTÊNCIA:
- [ ] Todos os módulos seguem o mesmo padrão
- [ ] Terminologia consistente entre módulos (Architecture, Responsibility, etc)
- [ ] Nível de detalhe apropriado ao contexto
- [ ] One-word keys ao invés de frases longas
```

---

## ETAPA 6: EXECUÇÃO FINAL

Execute na seguinte ordem:

1. **Gere o relatório** (ETAPA 2) - mostre ao usuário
2. **Aguarde confirmação** do usuário para prosseguir
3. **Aplique correções** (ETAPA 4) em todos os arquivos das categorias B e C
4. **Valide qualidade** (ETAPA 5) - checklist completo
5. **Execute testes** (`make test` ou `pytest`) para garantir que nada quebrou
6. **Relatório final**: Liste todos os arquivos modificados com resumo das mudanças

---

## 📋 EXEMPLO DE USO

**Entrada:** "Execute o prompt de validação de documentação semântica"

**Saída esperada:**
1. Relatório completo de análise (Categorias A, B, C)
2. Confirmação do usuário
3. Aplicação de correções em todos os arquivos
4. Validação de testes
5. Relatório final de mudanças

---

## 🎯 CRITÉRIOS DE SUCESSO

Ao final, todos os arquivos Python devem:
- ✅ Ter docstring de módulo com Architecture/Responsibility/Should/Boundaries
- ✅ Usar one-word keys consistentemente
- ✅ Ter docstrings de função/classe com Responsibility e Semantic Context
- ✅ Explicar POR QUÊ e CONTEXTO, não apenas O QUÊ
- ✅ Estar atualizados com o código atual
- ✅ Passar em todos os testes

---

## 🔧 ADAPTAÇÕES POR TIPO DE MÓDULO

### Módulos de Domínio (domain/):
Enfatize:
- Regras de negócio que implementa
- Invariantes que mantém
- Transformações que aplica

### Módulos de Infraestrutura (infrastructure/):
Enfatize:
- Recursos que gerencia
- Dependências externas
- Ciclo de vida dos recursos

### Módulos de API (api/):
Enfatize:
- Contrato com cliente externo
- Validações de entrada
- Transformações request → domain → response

### Módulos de Agentes (agents/):
Enfatize:
- Papel no fluxo conversacional
- Estado que gerencia
- Ferramentas/tools que utiliza

### Módulos de Observability (observability/):
Enfatize:
- O que é observado/logado
- Contexto capturado
- Como consumidores usam os dados

### Utilitários (utils/):
Enfatize:
- Casos de uso específicos
- Restrições/precondições
- Por que não está em outro lugar

---

## ⚠️ AVISOS IMPORTANTES

1. **NUNCA mude a lógica do código** - apenas docstrings
2. **NUNCA quebre backward compatibility** - apenas documentação
3. **SEMPRE valide com testes** - nada pode quebrar
4. **SEMPRE preserve type hints** - correspondem à documentação
5. **SEMPRE mantenha consistência** - mesmo padrão em todos os arquivos
6. **USE one-word keys** - Architecture, Responsibility, Should, Boundaries, Entry
7. **EVITE chaves verbosas** - não use "ARCHITECTURAL RESPONSIBILITY:", use "Architecture:"

---

### Rationale:
- **Mais limpo visualmente** - one-word keys reduzem ruído
- **Mais fácil de escanear** - chaves curtas facilitam leitura
- **Consistente com Pydantic/FastAPI** - padrão similar de fields
- **Alinhado com boas práticas Python** - concisão e clareza

---

## 🚀 EXECUÇÃO AUTOMÁTICA

Quando este prompt for executado, o LLM deve:
1. Ler `/.project/docs/refact/semantic_docstrings.md`
2. Analisar todos os arquivos Python
3. Gerar relatório completo
4. Aplicar correções usando one-word keys
5. Validar com testes
6. Reportar resultados

**Resultado esperado:** 100% dos arquivos Python com documentação semântica completa, atualizada e usando one-word keys.
```

---

## 📚 Referências

- Princípio base: `/.project/docs/refact/semantic_docstrings.md`
- Zen of Python: "Readability counts", "Explicit is better than implicit"

---

## 💡 Uso Futuro

Este prompt pode ser usado sempre que:
- Adicionar novos módulos ao projeto
- Refatorar módulos existentes
- Fazer code review focado em documentação
- Onboarding de novos desenvolvedores
- Garantir qualidade de documentação antes de merge

**Como usar:**
1. Copie o conteúdo da seção "Como Usar Este Prompt"
2. Cole no chat com o LLM (Claude, GPT, etc)
3. Aguarde o relatório de análise
4. Confirme para aplicar correções
5. Valide resultados com testes