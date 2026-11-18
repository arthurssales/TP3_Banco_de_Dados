-- =====================================================================
-- TP3 - Banco de Dados | 02_insert.sql
-- Execute DEPOIS de 01_create.sql e ANTES de 03_objects.sql
-- =====================================================================

-- ---------- MEDICO ----------
INSERT INTO medico (id_usuario, nome, sobrenome, email, senha, data_de_nascimento, sexo, crm, valor_da_consulta, telefone_profissional) VALUES
 (1, 'Helena', 'Barbosa', 'helena.barbosa@clinica.com', 'hash_a1f3', '1978-03-12', 'F', 'CRM-CE 10234', 350.00, '(85) 3222-1001'),
 (2, 'Ricardo', 'Almeida', 'ricardo.almeida@clinica.com', 'hash_b2c4', '1982-07-25', 'M', 'CRM-CE 11876', 400.00, '(85) 3222-1002'),
 (3, 'Camila', 'Rocha', 'camila.rocha@clinica.com', 'hash_c3d5', '1985-11-02', 'F', 'CRM-CE 12990', 280.00, '(85) 3222-1003'),
 (4, 'Fernando', 'Teixeira', 'fernando.teixeira@clinica.com', 'hash_d4e6', '1975-01-30', 'M', 'CRM-CE 09455', 600.00, '(85) 3222-1004'),
 (5, 'Luciana', 'Menezes', 'luciana.menezes@clinica.com', 'hash_e5f7', '1990-09-18', 'F', 'CRM-CE 13721', 200.00, NULL);

-- ---------- ESPECIALIZAÇÕES ----------
INSERT INTO cardiologista (id_usuario, realiza_ecocardiograma) VALUES
 (1, TRUE),
 (2, FALSE);

INSERT INTO pediatra (id_usuario, faixa_etaria_atendida, atende_recem_nascidos) VALUES
 (3, '0 a 12 anos', TRUE);

INSERT INTO cirurgiao (id_usuario, area_cirurgica, tempo_experiencia) VALUES
 (4, 'Cirurgia geral', 22);

-- ---------- PACIENTE ----------
INSERT INTO paciente (id_usuario, nome, sobrenome, email, senha, data_de_nascimento, sexo, cpf, endereco, telefone) VALUES
 (1, 'Arthur',  'Sales',    'arthur.sales@email.com',     'hash_p601', '2005-05-28', 'M',  '11122233344', 'Rua das Flores, 100 - Fortaleza/CE',        '(85) 99911-0006'),
 (2, 'Theodorico', 'Vale',     'theo.vale@email.com',     'hash_p702', '2006-02-14', 'M',  '22233344455', 'Av. Beira Mar, 2500 - Fortaleza/CE',        '(85) 99911-0007'),
 (3, 'Carlos',  'Pereira',  'carlos.pereira@email.com',   'hash_p803', '1968-12-05', 'M',  '33344455566', 'Rua Padre Valdevino, 45 - Fortaleza/CE',    '(85) 99911-0008'),
 (4, 'Daniela', 'Souza',    'daniela.souza@email.com',    'hash_p904', '1988-06-21', 'F',  '44455566677', 'Rua Silva Jatahy, 300 - Fortaleza/CE',      '(85) 99911-0009'),
 (5, 'Eduardo', 'Nogueira', 'eduardo.nogueira@email.com', 'hash_p105', '2019-08-09', 'M',  '55566677788', 'Rua Barão de Studart, 12 - Fortaleza/CE',   NULL),
 (6, 'Fabiana', 'Costa',    'fabiana.costa@email.com',    'hash_p116', '1973-10-30', 'F',  '66677788899', 'Av. Santos Dumont, 800 - Fortaleza/CE',     '(85) 99911-0011'),
 (7, 'Gustavo', 'Ribeiro',  'gustavo.ribeiro@email.com',  'hash_p127', '1999-04-17', 'M',  '77788899900', 'Rua Tibúrcio Cavalcante, 77 - Fortaleza/CE','(85) 99911-0012'),
 (8, 'Heloisa', NULL,       'heloisa@email.com',          'hash_p138', '2023-01-11', NULL, '88899900011', 'Rua Costa Barros, 150 - Fortaleza/CE',      NULL);

-- ---------- PLANO ----------
INSERT INTO plano (id_plano, nome_do_plano, telefone_de_contato) VALUES
 (1, 'Unimed Fortaleza', '0800 275 0000'),
 (2, 'Hapvida',          '0800 979 2000'),
 (3, 'Bradesco Saúde',   '0800 701 2700'),
 (4, 'SulAmérica Saúde', NULL);

-- ---------- UTILIZA ----------
INSERT INTO utiliza (id_usuario_medico, id_usuario_paciente, id_plano) VALUES
 (1, 1, 1),
 (1, 3, 3),
 (1, 6, 2),
 (2, 3, 3),
 (3, 5, 2),
 (3, 8, 1),
 (4, 4, NULL),
 (4, 7, 4),
 (5, 2, 1),
 (5, 1, 1),
 (2, 6, NULL);

-- ---------- CONSULTA ----------
INSERT INTO consulta (id_consulta, data_hora, status, descricao, id_usuario_medico, id_usuario_paciente) VALUES
 (1,  '2026-09-02 09:00', 'Realizada', 'Avaliação cardiológica de rotina',          1, 1),
 (2,  '2026-09-03 10:30', 'Realizada', 'Dor torácica leve; solicitado ecocardiograma', 1, 3),
 (3,  '2026-09-10 14:00', 'Realizada', 'Acompanhamento de hipertensão',              2, 3),
 (4,  '2026-09-15 08:30', 'Realizada', 'Consulta pediátrica de rotina',              3, 5),
 (5,  '2026-09-18 15:00', 'Realizada', 'Avaliação pré-operatória',                   4, 4),
 (6,  '2026-10-01 11:00', 'Realizada', 'Check-up geral',                             5, 2),
 (7,  '2026-10-05 09:30', 'Agendada', 'Consulta no pediatra',                        1, 6),
 (8,  '2026-10-08 16:00', 'Realizada', 'Retorno pós-cirúrgico',                      4, 7),
 (9,  '2026-10-14 10:00', 'Realizada', 'Vacinação e puericultura',                   3, 8),
 (10, '2026-10-20 14:30', 'Realizada', 'Controle de pressão arterial',               1, 6),
 (11, '2026-11-04 09:00', 'Realizada', 'Gripe e febre',                              5, 1),
 (12, '2026-11-10 13:00', 'Realizada', 'Arritmia - holter solicitado',               2, 6),
 (13, '2026-11-25 09:00', 'Agendada',  'Retorno cardiológico',                       1, 1),
 (14, '2026-11-26 15:30', 'Agendada',  'Consulta pediátrica de retorno',             3, 5),
 (15, '2026-12-02 10:00', 'Agendada',  NULL,                                         5, 2);

-- ---------- CONTA ----------
INSERT INTO conta (id_conta, situacao, valor_cobrado, data_de_vencimento, id_usuario, id_consulta) VALUES
 (1,  'Paga',      350.00, '2026-09-17', 1, 1),
 (2,  'Paga',      350.00, '2026-09-18', 3, 2),
 (3,  'Paga',      400.00, '2026-09-25', 3, 3),
 (4,  'Paga',      280.00, '2026-09-30', 5, 4),
 (5,  'Pendente',   600.00, '2026-10-03', 4, 5),
 (6,  'Paga',      200.00, '2026-10-16', 2, 6),
 (7,  'Pendente', 350.00, '2026-10-20', 6, 7),
 (8,  'Paga',      600.00, '2026-10-23', 7, 8),
 (9,  'Pendente',  280.00, '2026-11-29', 8, 9),
 (10, 'Pendente',  350.00, '2026-11-19', 6, 10),
 (11, 'Pendente',  200.00, '2026-11-19', 1, 11),
 (12, 'Pendente',  400.00, '2026-11-25', 6, 12);

-- ---------- RECEITA ----------
INSERT INTO receita (id_receita, prescricao, orientacao, data_validade, id_consulta) VALUES
 (1, 'Losartana 50 mg - 1 comprimido ao dia',            'Aferir pressão semanalmente',      '2027-03-02', 3),
 (2, 'Ácido acetilsalicílico 100 mg - 1 comp. ao dia',   'Tomar após o almoço',              '2026-12-03', 2),
 (3, 'Vitamina D 2000 UI - 1 cápsula ao dia',            NULL,                               '2027-04-01', 6),
 (4, 'Dipirona 500 mg - 1 comp. a cada 6 horas',         'Se febre persistir, retornar',     '2026-12-04', 11),
 (5, 'Amoxicilina 250 mg/5 ml - 5 ml a cada 8 horas',    'Completar 7 dias de tratamento',   '2026-10-22', 9),
 (6, 'Atenolol 25 mg - 1 comprimido ao dia',             'Evitar cafeína',                   '2027-05-10', 12),
 (7, 'Anlodipino 5 mg - 1 comprimido ao dia',            'Reavaliar em 30 dias',             '2027-04-20', 10);

-- ---------- Ajuste das sequências ----------
SELECT setval(pg_get_serial_sequence('medico',   'id_usuario'),  (SELECT MAX(id_usuario)  FROM medico));
SELECT setval(pg_get_serial_sequence('paciente', 'id_usuario'),  (SELECT MAX(id_usuario)  FROM paciente));
SELECT setval(pg_get_serial_sequence('plano',    'id_plano'),    (SELECT MAX(id_plano)    FROM plano));
SELECT setval(pg_get_serial_sequence('consulta', 'id_consulta'), (SELECT MAX(id_consulta) FROM consulta));
SELECT setval(pg_get_serial_sequence('conta',    'id_conta'),    (SELECT MAX(id_conta)    FROM conta));
SELECT setval(pg_get_serial_sequence('receita',  'id_receita'),  (SELECT MAX(id_receita)  FROM receita));