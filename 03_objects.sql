-- =====================================================================
-- TP3 - Banco de Dados | 03_objects.sql  (rascunho de apoio ao 04_tests.sql)
-- Execute DEPOIS de 02_insert.sql.
-- =====================================================================

-- ---------- VIEW ----------
CREATE OR REPLACE VIEW vw_resumo_consultas AS
SELECT c.id_consulta,
       c.data_hora,
       c.status,
       m.nome || ' ' || COALESCE(m.sobrenome, '') AS medico,
       m.crm,
       p.nome || ' ' || COALESCE(p.sobrenome, '') AS paciente,
       ct.situacao      AS situacao_conta,
       ct.valor_cobrado
FROM consulta c
JOIN medico   m  ON m.id_usuario  = c.id_usuario_medico
JOIN paciente p  ON p.id_usuario  = c.id_usuario_paciente
LEFT JOIN conta ct ON ct.id_consulta = c.id_consulta;

-- ---------- ÍNDICE ----------
-- Acelera o histórico de consultas de um paciente em ordem cronológica.
CREATE INDEX idx_consulta_paciente_data
    ON consulta (id_usuario_paciente, data_hora);

-- ---------- GATILHO 1: valida e completa a conta ----------
CREATE OR REPLACE FUNCTION fn_validar_conta() RETURNS trigger AS $$
DECLARE
    v_paciente INTEGER;
BEGIN
    SELECT id_usuario_paciente INTO v_paciente
      FROM consulta WHERE id_consulta = NEW.id_consulta;

    IF v_paciente IS DISTINCT FROM NEW.id_usuario THEN
        RAISE EXCEPTION 'A conta deve pertencer ao paciente da consulta % (esperado %, informado %)',
            NEW.id_consulta, v_paciente, NEW.id_usuario;
    END IF;

    IF NEW.data_de_vencimento IS NULL THEN
        NEW.data_de_vencimento := CURRENT_DATE + 15;  -- regra: vencimento padrão de 15 dias
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_conta
BEFORE INSERT OR UPDATE ON conta
FOR EACH ROW EXECUTE FUNCTION fn_validar_conta();