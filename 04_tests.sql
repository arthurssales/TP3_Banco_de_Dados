-- =====================================================================
-- TP3 - Banco de Dados | 04_tests.sql
-- (testes que alteram dados terminam em ROLLBACK).
-- =====================================================================

-- ---------------------------------------------------------------
-- T1. JOIN: consultas com nome do médico e do paciente
-- ---------------------------------------------------------------
SELECT c.id_consulta, c.data_hora, c.status,
       m.nome AS medico, p.nome AS paciente
FROM consulta c
JOIN medico   m ON m.id_usuario = c.id_usuario_medico
JOIN paciente p ON p.id_usuario = c.id_usuario_paciente
ORDER BY c.data_hora;

-- ---------------------------------------------------------------
-- T2. GROUP BY + função de agregação: faturamento por médico
-- ---------------------------------------------------------------
SELECT m.nome AS medico,
       COUNT(*)              AS qtd_contas,
       SUM(ct.valor_cobrado) AS total_cobrado
FROM conta ct
JOIN consulta c  ON c.id_consulta = ct.id_consulta
JOIN medico   m  ON m.id_usuario = c.id_usuario_medico
GROUP BY m.nome
ORDER BY total_cobrado DESC;

-- ---------------------------------------------------------------
-- T3. HAVING: médicos com mais de 2 consultas realizadas
-- ---------------------------------------------------------------
SELECT c.id_usuario_medico, m.nome, COUNT(*) AS realizadas
FROM consulta c
JOIN medico m ON m.id_usuario = c.id_usuario_medico
WHERE c.status = 'Realizada'
GROUP BY c.id_usuario_medico, m.nome
HAVING COUNT(*) > 2;

-- ---------------------------------------------------------------
-- T4. Subconsulta: pacientes com conta vencida
-- ---------------------------------------------------------------
SELECT p.id_usuario, p.nome, p.sobrenome
FROM paciente p
WHERE p.id_usuario IN (SELECT ct.id_usuario
                       FROM conta ct
                       WHERE ct.situacao = 'Pendente');

-- Subconsulta correlata: pacientes que têm ao menos uma consulta agendada
SELECT p.nome
FROM paciente p
WHERE EXISTS (SELECT 1 FROM consulta c
              WHERE c.id_usuario_paciente = p.id_usuario
                AND c.status IN ('Agendada'));

-- ---------------------------------------------------------------
-- T5. VIEW: agenda futura com situação financeira
-- ---------------------------------------------------------------
SELECT * FROM vw_resumo_consultas
WHERE status = 'Agendada'
ORDER BY data_hora;

-- ---------------------------------------------------------------
-- T6. Consulta compatível com o índice idx_consulta_paciente_data
--     (com poucas linhas o planner pode preferir Seq Scan; o
--      SET enable_seqscan força a demonstração do uso do índice)
-- ---------------------------------------------------------------
SET enable_seqscan = off;
EXPLAIN
SELECT id_consulta, data_hora, status
FROM consulta
WHERE id_usuario_paciente = 1
ORDER BY data_hora;
SET enable_seqscan = on;

-- ---------------------------------------------------------------
-- T7. Restrições de integridade (cada bloco captura o erro esperado)
-- ---------------------------------------------------------------
DO $$
BEGIN
    -- 7a. UNIQUE: e-mail duplicado
    BEGIN
        INSERT INTO paciente (nome, email, senha, data_de_nascimento, cpf)
        VALUES ('Teste', 'arthur.sales@email.com', 'x', '2000-01-01', '99900011122');
        RAISE NOTICE '7a FALHOU: aceitou e-mail duplicado';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE '7a OK: e-mail duplicado rejeitado (UNIQUE)';
    END;

    -- 7b. CHECK: status inválido
    BEGIN
        INSERT INTO consulta (data_hora, status, id_usuario_medico, id_usuario_paciente)
        VALUES ('2026-12-10 09:00', 'Em andamento', 1, 1);
        RAISE NOTICE '7b FALHOU: aceitou status inválido';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE '7b OK: status inválido rejeitado (CHECK)';
    END;

    -- 7c. FK: paciente inexistente
    BEGIN
        INSERT INTO consulta (data_hora, id_usuario_medico, id_usuario_paciente)
        VALUES ('2026-12-10 09:00', 1, 999);
        RAISE NOTICE '7c FALHOU: aceitou FK inexistente';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE '7c OK: paciente inexistente rejeitado (FK)';
    END;

    -- 7d. NOT NULL: CPF obrigatório
    BEGIN
        INSERT INTO paciente (nome, email, senha, data_de_nascimento, cpf)
        VALUES ('Teste', 'teste.cpf@email.com', 'x', '2000-01-01', NULL);
        RAISE NOTICE '7d FALHOU: aceitou CPF nulo';
    EXCEPTION WHEN not_null_violation THEN
        RAISE NOTICE '7d OK: CPF nulo rejeitado (NOT NULL)';
    END;

    -- 7e. UNIQUE composto: médico com dois atendimentos no mesmo horário
    BEGIN
        INSERT INTO consulta (data_hora, id_usuario_medico, id_usuario_paciente)
        VALUES ('2026-11-25 09:00', 1, 2);
        RAISE NOTICE '7e FALHOU: aceitou conflito de horário';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE '7e OK: conflito de horário rejeitado (UNIQUE composto)';
    END;
END $$;

-- ---------------------------------------------------------------
-- T8. Gatilhos (dentro de transação, desfeitos no final)
-- ---------------------------------------------------------------
BEGIN;

-- 8a. Vencimento padrão (+15 dias) preenchido pelo gatilho
INSERT INTO consulta (id_consulta, data_hora, id_usuario_medico, id_usuario_paciente)
VALUES (100, '2026-12-15 10:00', 2, 4);

INSERT INTO conta (valor_cobrado, id_usuario, id_consulta)
VALUES (400.00, 4, 100);

SELECT id_conta, situacao, data_de_vencimento,
       data_de_vencimento - CURRENT_DATE AS dias_ate_vencer
FROM conta WHERE id_consulta = 100;

-- 8b. Conta de paciente diferente do da consulta deve ser barrada
DO $$
BEGIN
    BEGIN
        INSERT INTO conta (valor_cobrado, id_usuario, id_consulta)
        VALUES (50.00, 2, 13);   -- consulta 13 pertence ao paciente 1
        RAISE NOTICE '8b FALHOU: gatilho não barrou conta de outro paciente';
    EXCEPTION WHEN raise_exception THEN
        RAISE NOTICE '8b OK: %', SQLERRM;
    END;
END $$;

-- ---------------------------------------------------------------
-- T9. Transação explícita: pagamento de conta com COMMIT / ROLLBACK
-- ---------------------------------------------------------------
BEGIN;
UPDATE conta SET situacao = 'Paga' WHERE id_conta = 10;
SELECT id_conta, situacao FROM conta WHERE id_conta = 10;   
ROLLBACK;
SELECT id_conta, situacao FROM conta WHERE id_conta = 10;   

BEGIN;
UPDATE conta SET situacao = 'Paga' WHERE id_conta = 10;
COMMIT;
SELECT id_conta, situacao FROM conta WHERE id_conta = 10; 

-- Restaura o estado original para permitir reexecução do script
UPDATE conta SET situacao = 'Pendente' WHERE id_conta = 10;