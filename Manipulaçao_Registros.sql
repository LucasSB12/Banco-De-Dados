-- PREPARAÇÃO
CREATE DATABASE IF NOT EXISTS bd_gestao_ativos_industriais;

USE bd_gestao_ativos_industriais;

-- TABELA SETORES
CREATE TABLE IF NOT EXISTS setores (
    id_setor INT AUTO_INCREMENT PRIMARY KEY,
    codigo_setor VARCHAR(12) NOT NULL UNIQUE,
    nome_setor VARCHAR(70) NOT NULL,
    bloco_setor VARCHAR(30) NOT NULL,
    ramal_setor VARCHAR(10),
    ativo_setor BOOLEAN NOT NULL DEFAULT TRUE
);

-- TABELA TECNICOS
CREATE TABLE IF NOT EXISTS tecnicos (
    id_tecnico INT AUTO_INCREMENT PRIMARY KEY,
    matricula_tecnico VARCHAR(12) NOT NULL UNIQUE,
    nome_tecnico VARCHAR(80) NOT NULL,
    especialidade_tecnico VARCHAR(50) NOT NULL,
    telefone_tecnico VARCHAR(16),
    id_setor INT NOT NULL,
    disponivel_tecnico BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_tecnicos_id_setor
        FOREIGN KEY (id_setor) REFERENCES setores(id_setor)
);

-- TABELA EQUIPAMENTOS
CREATE TABLE IF NOT EXISTS equipamentos (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    patrimonio_equipamento VARCHAR(16) NOT NULL UNIQUE,
    descricao_equipamento VARCHAR(90) NOT NULL,
    categoria_equipamento VARCHAR(40) NOT NULL,
    id_setor INT NOT NULL,
    data_aquisicao_equipamento DATE NOT NULL,
    custo_equipamento DECIMAL(10,2) NOT NULL,
    situacao_equipamento VARCHAR(25) NOT NULL DEFAULT 'Operacional',
    CONSTRAINT fk_equipamentos_id_setor
        FOREIGN KEY (id_setor) REFERENCES setores(id_setor)
);

-- TABELA ORDENS DE SERVICO
CREATE TABLE IF NOT EXISTS ordens_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    codigo_os VARCHAR(16) NOT NULL UNIQUE,
    id_equipamento INT NOT NULL,
    id_tecnico INT NOT NULL,
    descricao_os VARCHAR(120) NOT NULL,
    prioridade_os VARCHAR(15) NOT NULL,
    status_os VARCHAR(20) NOT NULL DEFAULT 'Aberta',
    data_abertura_os DATE NOT NULL,
    CONSTRAINT fk_ordens_servico_id_equipamento
        FOREIGN KEY (id_equipamento)
        REFERENCES equipamentos(id_equipamento),
    CONSTRAINT fk_ordens_servico_id_tecnico
        FOREIGN KEY (id_tecnico)
        REFERENCES tecnicos(id_tecnico)
);

-- TABELA INTERVENCOES
CREATE TABLE IF NOT EXISTS intervencoes (
    id_intervencao INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    id_tecnico INT NOT NULL,
    data_intervencao DATE NOT NULL,
    procedimento_intervencao VARCHAR(130) NOT NULL,
    horas_intervencao DECIMAL(5,2) NOT NULL,
    concluida_intervencao BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_intervencoes_id_os
        FOREIGN KEY (id_os) REFERENCES ordens_servico(id_os),
    CONSTRAINT fk_intervencoes_id_tecnico
        FOREIGN KEY (id_tecnico) REFERENCES tecnicos(id_tecnico)
);

-- REGISTROS INICIAIS: SETORES
INSERT IGNORE INTO setores
(codigo_setor, nome_setor, bloco_setor, ramal_setor) VALUES
('ST-01', 'Usinagem', 'B2', '211'),
('ST-02', 'Montagem', 'B3', '212'),
('ST-03', 'Automacao', 'B1', '213'),
('ST-04', 'Qualidade', 'B2', '214'),
('ST-05', 'Manutencao', 'B3', '215'),
('ST-06', 'TI Industrial', 'B1', '216'),
('ST-07', 'Logistica', 'B2', '217'),
('ST-08', 'Energia', 'B3', '218'),
('ST-09', 'Metrologia', 'B1', '219'),
('ST-10', 'Engenharia', 'B2', '220'),
('ST-11', 'Prototipagem', 'B4', '221'),
('ST-12', 'Robotica', 'B4', '222'),
('ST-13', 'Laboratorio Iot', 'B5', '223');

UPDATE setores
SET ramal_setor = '310'
WHERE codigo_setor = 'ST-01';

DELETE FROM setores
WHERE id_setor = 12;

DELETE FROM setores
WHERE id_setor = 13
  AND codigo_setor = 'ST-13';

-- REGISTROS INICIAIS: TECNICOS
INSERT IGNORE INTO tecnicos
(matricula_tecnico, nome_tecnico, especialidade_tecnico,
 telefone_tecnico, id_setor) VALUES
('TC-001', 'Ana Ribeiro', 'Eletrica', '45990000001', 1),
('TC-002', 'Bruno Lima', 'Automacao', '45990000002', 2),
('TC-003', 'Carla Nunes', 'Redes', '45990000003', 3),
('TC-004', 'Diego Alves', 'Software', '45990000004', 4),
('TC-005', 'Elisa Martins', 'Mecanica', '45990000005', 5),
('TC-006', 'Fabio Costa', 'Eletrica', '45990000006', 6),
('TC-011', 'Lucas Ferreira', 'Instrumentacao', '45990000111', 11);

UPDATE tecnicos
SET especialidade_tecnico = 'Automacao Industrial',
    telefone_tecnico = '45901112222'
WHERE id_tecnico = 2;

-- REGISTROS INICIAIS: EQUIPAMENTOS
INSERT IGNORE INTO equipamentos
(patrimonio_equipamento, descricao_equipamento,
 categoria_equipamento, id_setor,
 data_aquisicao_equipamento, custo_equipamento) VALUES
('AT-001', 'Torno CNC', 'Mecanica', 1, '2025-06-15', 3175.50),
('AT-002', 'Esteira modular', 'Transporte', 2, '2025-06-15', 8551.00),
('AT-003', 'CLP industrial', 'Automacao', 3, '2025-06-15', 4255.50),
('AT-004', 'Bancada de ensaios', 'Teste', 4, '2025-06-15', 5202.00),
('AT-005', 'Prensa hidraulica', 'Mecanica', 5, '2025-06-15', 5877.50),
('AT-006', 'Servidor SQL', 'Servidor', 6, '2025-07-15', 6553.00),
('AT-007', 'Leitor RFID', 'Identificacao', 7, '2025-08-15', 7228.50),
('AT-008', 'Inversor de frequencia', 'Eletrica', 8, '2025-09-15', 7904.00),
('AT-009', 'Calibrador digital', 'Medicao', 9, '2025-10-15', 8579.50),
('AT-010', 'Estacao CAD', 'Computador', 10, '2025-02-15', 9255.00),
('AT-011', 'Impressora 3D industrial', 'Prototipagem', 11, '2026-10-01', 18500.00),
('AT-012', 'Gateway Iot', 'Redes', 13, '2026-10-02', 3900.00),
('AT-013', 'Roteador industrial reserva', 'Redes', 6, '2026-10-10', 2100.00);

UPDATE equipamentos
SET situacao_equipamento = 'Reserva',
    id_setor = 10
WHERE patrimonio_equipamento = 'AT-013';

UPDATE equipamentos
SET custo_equipamento = custo_equipamento + 250.00
WHERE id_equipamento IN (2, 5)
  AND custo_equipamento BETWEEN 3000.00 AND 7000.00;

UPDATE equipamentos
SET id_setor = 6
WHERE id_equipamento = 12;

UPDATE equipamentos
SET situacao_equipamento = 'Em avaliacao'
WHERE id_equipamento = 11;

DELETE FROM equipamentos
WHERE patrimonio_equipamento = 'AT-013'
  AND id_equipamento = 13;

-- REGISTROS INICIAIS: ORDENS DE SERVICO
INSERT IGNORE INTO ordens_servico
(codigo_os, id_equipamento, id_tecnico, descricao_os,
 prioridade_os, status_os, data_abertura_os) VALUES
('OS-2026-001', 1, 1, 'Inspecao preventiva de torno CNC', 'Media', 'Em andamento', '2026-09-01'),
('OS-2026-002', 2, 2, 'Inspecao preventiva de esteira modular', 'Alta', 'Concluida', '2026-09-02'),
('OS-2026-003', 3, 3, 'Inspecao preventiva de CLP industrial', 'Baixa', 'Aberta', '2026-09-03'),
('OS-2026-004', 4, 4, 'Inspecao preventiva de bancada de ensaios', 'Media', 'Em andamento', '2026-09-04'),
('OS-2026-005', 5, 5, 'Inspecao preventiva de prensa hidraulica', 'Alta', 'Concluida', '2026-09-05'),
('OS-2026-006', 6, 6, 'Inspecao preventiva de servidor SQL', 'Baixa', 'Aberta', '2026-09-06'),
('OS-2026-007', 7, 7, 'Inspecao preventiva de leitor RFID', 'Media', 'Em andamento', '2026-09-07'),
('OS-2026-008', 8, 8, 'Inspecao preventiva de inversor de frequencia', 'Alta', 'Concluida', '2026-09-08'),
('OS-2026-009', 9, 9, 'Inspecao preventiva de calibrador digital', 'Baixa', 'Aberta', '2026-09-09'),
('OS-2026-010', 10, 10, 'Inspecao preventiva de estacao CAD', 'Media', 'Em andamento', '2026-09-10'),
('OS-2026-011', 11, 11, 'Calibracao inicial de impressora 3D', 'Alta', 'Aberta', '2026-10-08'),
('OS-2026-012', 12, 11, 'Teste administrativo sem atendimento', 'Baixa', 'Aberta', '2026-10-05');

UPDATE ordens_servico
SET status_os = 'Concluida'
WHERE id_os = 11;

UPDATE ordens_servico
SET prioridade_os = 'Alta'
WHERE status_os = 'Em andamento'
  AND prioridade_os = 'Media'
  AND id_os IN (1, 4, 7, 10);

DELETE FROM ordens_servico
WHERE id_os = LAST_INSERT_ID()
  AND prioridade_os = 'Baixa';

DELETE FROM ordens_servico
WHERE id_os = 11
  AND codigo_os = 'OS-2026-011';

-- REGISTROS INICIAIS: INTERVENCOES
INSERT IGNORE INTO intervencoes
(id_os, id_tecnico, data_intervencao,
 procedimento_intervencao, horas_intervencao,
 concluida_intervencao) VALUES
(1, 1, '2026-09-11', 'Verificacao tecnica e registro da OS 001', 0.75, FALSE),
(2, 2, '2026-09-12', 'Verificacao tecnica e registro da OS 002', 1.0, FALSE),
(3, 3, '2026-09-13', 'Verificacao tecnica e registro da OS 003', 1.25, TRUE),
(4, 4, '2026-09-14', 'Verificacao tecnica e registro da OS 004', 1.5, FALSE),
(5, 5, '2026-09-15', 'Verificacao tecnica e registro da OS 005', 1.75, FALSE),
(6, 6, '2026-09-16', 'Verificacao tecnica e registro da OS 006', 2.0, TRUE),
(7, 7, '2026-09-17', 'Verificacao tecnica e registro da OS 007', 2.25, FALSE),
(8, 8, '2026-09-18', 'Verificacao tecnica e registro da OS 008', 2.5, FALSE),
(9, 9, '2026-09-19', 'Verificacao tecnica e registro da OS 009', 2.75, TRUE),
(10, 10, '2026-09-20', 'Verificacao tecnica e registro da OS 010', 3.0, FALSE),
(11, 11, '2026-10-04', 'Diagnostico e ajuste de extrusora', 1.60, FALSE);

UPDATE intervencoes
SET concluida_intervencao = TRUE
WHERE id_intervencao = 11;

DELETE FROM intervencoes
WHERE id_intervencao = 11
  AND id_os = 11;
