# Projeto Resiclame - Sistema de Gestão de Reciclagem Inteligente

## Escopo do Sistema

O sistema permitirá:
- Cadastro de cidadãos e empresas participantes.
- Registro de pontos de coleta e cooperativas.
- Agendamento e acompanhamento da coleta seletiva.
- Sistema de pontuação e recompensas.
- Geração de relatórios de impacto ambiental.

---

## Estrutura do Projeto

- **scripts/**: Contém os scripts SQL do projeto.
  - `resiclame.sql`: Script principal para criação das tabelas e relações do banco de dados.
  - `proposta.sql`: Script complementar, incluindo funcionalidades adicionais ou propostas de melhoria.

- **diagramas/**: Diagrams do banco de dados em PNG e txt.
- - `der_Conceitual.png` / `der_Conceitual.txt`: Diagrama Conceitual.
  - `der_logico.png` / `der_logico.txt`: Diagrama lógico.
  - `der_fisico.png` / `der_fisico.txt`: Diagrama físico.

- **codigo/**: Código-fonte do projeto, incluindo o analisador léxico e demais arquivos relacionados.

- **README.md**: Este arquivo com instruções.

---

## Instruções de Execução

1. **Importação do Banco de Dados (MySQL)**:
   - Abra o MySQL Workbench ou outro cliente MySQL.
   - Execute primeiro o script `proposta.sql`, caso necessário.
   - Execute em seguida o script `resiclame.sql` para criar todas as tabelas e relações do banco.

2. **Diagrama**:
   - As imagens em PNG estão disponíveis na pasta `diagramas/`.
   - Podem ser abertas diretamente em qualquer visualizador de imagens.

3. **Código**:
   - Todos os arquivos-fonte estão na pasta `reciclame/`.
   - Compile os arquivos em C conforme necessário:
     ```bash
     gcc lexer.c -o lexer
     ./lexer
     ```

4. **Relatório**:
   - O relatório técnico detalha a implementação, explicações do projeto e instruções adicionais.


# Sustentabilidade_Sistema-Reciclagem-Inteligente
