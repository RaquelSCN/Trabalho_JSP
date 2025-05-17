CREATE DATABASE felixbus;
USE felixbus;

-- Tabela de Utilizadores (Clientes, Funcionários e Admins)
CREATE TABLE utilizadores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('cliente', 'funcionario', 'administrador') NOT NULL
);

-- Tabela de Clientes
CREATE TABLE clientes (
    id_utilizador INT PRIMARY KEY,
    telefone VARCHAR(20),
    FOREIGN KEY (id_utilizador) REFERENCES utilizadores(id) ON DELETE CASCADE
);

-- Tabela de Funcionários
CREATE TABLE funcionarios (
    id_utilizador INT PRIMARY KEY,
    cargo VARCHAR(50),
    FOREIGN KEY (id_utilizador) REFERENCES utilizadores(id) ON DELETE CASCADE
);

-- Tabela de Administradores
CREATE TABLE administradores (
    id_utilizador INT PRIMARY KEY,
    FOREIGN KEY (id_utilizador) REFERENCES utilizadores(id) ON DELETE CASCADE
);

-- Tabela de Rotas
CREATE TABLE rotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    capacidade INT NOT NULL
);

-- Tabela de Bilhetes
CREATE TABLE bilhetes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_rota INT NOT NULL,
    data_viagem DATE NOT NULL,
    hora_viagem TIME NOT NULL,
    status ENUM('ativo', 'usado', 'cancelado') DEFAULT 'ativo',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_utilizador) ON DELETE CASCADE,
    FOREIGN KEY (id_rota) REFERENCES rotas(id) ON DELETE CASCADE
);

-- Tabela de Carteiras (Clientes e FelixBus)
CREATE TABLE carteiras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNIQUE NULL, -- NULL para a carteira da empresa
    saldo DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_utilizador) ON DELETE CASCADE
);

-- Tabela de Transações
CREATE TABLE transacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_carteira INT NOT NULL,
    tipo ENUM('adicionar', 'retirar', 'compra_bilhete') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_carteira) REFERENCES carteiras(id) ON DELETE CASCADE
);

-- Tabela de Alertas/Promoções
CREATE TABLE alertas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL
);


-- Inserir as informações

-- Criar carteira especial da empresa (id_cliente NULL)
INSERT INTO carteiras (id_cliente, saldo) VALUES (NULL, 0.00);

-- Criar utilizadores padrão
INSERT INTO utilizadores (nome, email, senha, tipo) VALUES
('Cliente', 'cliente@felixbus.com', SHA2('cliente', 256), 'cliente'),
('Funcionário', 'funcionario@felixbus.com', SHA2('funcionario', 256), 'funcionario'),
('Admin', 'admin@felixbus.com', SHA2('admin', 256), 'administrador');

-- Associar ao perfil correto
INSERT INTO clientes (id_utilizador, telefone) VALUES (1, '912345678');
INSERT INTO funcionarios (id_utilizador, cargo) VALUES (2, 'Atendimento');
INSERT INTO administradores (id_utilizador) VALUES (3);

-- Criar carteira do cliente de teste
INSERT INTO carteiras (id_cliente, saldo) VALUES (1, 50.00);

-- Rotas 
INSERT INTO rotas (origem, destino, preco, capacidade) VALUES
('Lisboa', 'Porto', 20.00, 50),
('Lisboa', 'Coimbra', 15.00, 45),
('Porto', 'Faro', 25.00, 40);




