USE master if exists (SELECT * FROM SYS.databases WHERE name = 'powerflexdb')

DROP DATABASE powerflexdb
GO

CREATE DATABASE powerflexdb
GO 

USE powerflexdb
GO


CREATE TABLE usuarios (
id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf VARCHAR(100) NULL,
email VARCHAR(45) NOT NULL,
password VARCHAR(250) NOT NULL,
cod_status BIT NOT NULL,
)

CREATE TABLE telefones(
id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
numero VARCHAR(15) NOT NULL,
cod_status BIT NOT NULL,
usuario_id BIGINT NOT NULL,
CONSTRAINT fk_telefone_usuario_id FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
)

--Recursos necess�rios para o sistema do login
CREATE TABLE papeis(
id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
nome_papel VARCHAR(45) NOT NULL,
descricao_papel VARCHAR(250) NULL,
cod_status_papel BIT NULL
)

CREATE TABLE usuarios_papeis(
usuario_id BIGINT NOT NULL,
papel_id BIGINT NOT NULL,
CONSTRAINT fk_usuarios_papeis_usuario_id FOREIGN KEY(usuario_id) REFERENCES usuarios(id),
CONSTRAINT fk_usuarios_papeis_papel_id FOREIGN KEY(papel_id) REFERENCES papeis(id)
)

CREATE TABLE clientes (
    cliente_id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_nascimento DATE
);


CREATE TABLE instrutores (
    instrutor_id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(50),
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);


CREATE TABLE aulas (
    aula_id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT,
    duracao TIME,   -- Duração da aula (por exemplo, 1 hora)
    instrutor_id BIGINT,
    FOREIGN KEY (instrutor_id) REFERENCES instrutores(instrutor_id)
);


CREATE TABLE agendamentos (
    agendamento_id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    cliente_id BIGINT,
    aula_id BIGINT,
    data_hora DATETIME,  -- Data e hora do agendamento
    status VARCHAR(20) DEFAULT 'pendente',  -- Status do agendamento (pendente, confirmado, cancelado)
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (aula_id) REFERENCES aulas(aula_id)
);

INSERT INTO clientes (nome, email, telefone, data_nascimento)
VALUES ('João Silva', 'joao@email.com', '123456789', '1990-05-10');

INSERT INTO instrutores (nome, especialidade, telefone, email)
VALUES ('Maria Oliveira', 'Yoga', '987654321', 'maria@email.com');

INSERT INTO aulas (nome, descricao, duracao, instrutor_id)
VALUES ('Aula de Yoga', 'Aula de Yoga para iniciantes', '01:00:00', 1);

INSERT INTO agendamentos (cliente_id, aula_id, data_hora, status)
VALUES (1, 1, GETDATE(), 'pendente');


-- Verificar todos os agendamentos para um cliente:

SELECT a.nome AS aula, ag.data_hora, ag.status
FROM agendamentos ag
JOIN aulas a ON ag.aula_id = a.aula_id
WHERE ag.cliente_id = 1;


--Verificar todas as aulas de um instrutor:
SELECT a.nome AS aula, a.descricao, a.duracao
FROM aulas a
JOIN instrutores i ON a.instrutor_id = i.instrutor_id
WHERE i.instrutor_id = 1;

--Verificar todos os agendamentos para uma aula específica:

SELECT c.nome AS cliente, ag.data_hora, ag.status
FROM agendamentos ag
JOIN clientes c ON ag.cliente_id = c.cliente_id
WHERE ag.aula_id = 1;
