
DROP DATABASE IF EXISTS reciclame;
CREATE DATABASE reciclame CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE reciclame;


CREATE TABLE tipo_residuo (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE,
  descricao VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: pessoa
CREATE TABLE pessoa (
  cpf CHAR(11) PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  endereco_rua VARCHAR(150),
  endereco_numero VARCHAR(20),
  endereco_bairro VARCHAR(100),
  endereco_cidade VARCHAR(100),
  endereco_uf CHAR(2),
  data_nascimento DATE,
  telefone VARCHAR(20),
  email VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: empresa
CREATE TABLE empresa (
  cnpj CHAR(14) PRIMARY KEY,
  razao_social VARCHAR(200) NOT NULL,
  area_atuacao VARCHAR(150)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: cooperativa
CREATE TABLE cooperativa (
  id_coop INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  endereco_rua VARCHAR(150),
  endereco_numero VARCHAR(20),
  endereco_bairro VARCHAR(100),
  endereco_cidade VARCHAR(100),
  endereco_uf CHAR(2),
  capacidade_processamento INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: ponto_coleta
CREATE TABLE ponto_coleta (
  id_ponto INT AUTO_INCREMENT PRIMARY KEY,
  localizacao VARCHAR(255) NOT NULL,
  capacidade INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: recompensa (catálogo)
CREATE TABLE recompensa (
  id_recompensa INT AUTO_INCREMENT PRIMARY KEY,
  tipo VARCHAR(100) NOT NULL,
  valor DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: residuo
CREATE TABLE residuo (
  id_residuo INT AUTO_INCREMENT PRIMARY KEY,
  id_tipo INT NOT NULL,
  peso DECIMAL(10,3) NOT NULL,
  data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
  id_coop INT,
  cnpj_empresa CHAR(14),
  CONSTRAINT fk_residuo_tipo FOREIGN KEY (id_tipo) REFERENCES tipo_residuo(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_residuo_coop FOREIGN KEY (id_coop) REFERENCES cooperativa(id_coop) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_residuo_empresa FOREIGN KEY (cnpj_empresa) REFERENCES empresa(cnpj) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: material_especial (especialização de residuo)
CREATE TABLE material_especial (
  id_residuo INT PRIMARY KEY,
  tipo_especial VARCHAR(100),
  cuidado_armazenamento TEXT,
  CONSTRAINT fk_material_residuo FOREIGN KEY (id_residuo) REFERENCES residuo(id_residuo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: ponto_coleta_aceita (multivalorada: tipos aceitos por ponto)
CREATE TABLE ponto_coleta_aceita (
  id_ponto INT NOT NULL,
  id_tipo INT NOT NULL,
  PRIMARY KEY (id_ponto, id_tipo),
  CONSTRAINT fk_ponto_aceita_ponto FOREIGN KEY (id_ponto) REFERENCES ponto_coleta(id_ponto) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ponto_aceita_tipo FOREIGN KEY (id_tipo) REFERENCES tipo_residuo(id_tipo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: coleta
CREATE TABLE coleta (
  id_coleta INT AUTO_INCREMENT PRIMARY KEY,
  data DATETIME NOT NULL,
  status ENUM('agendada','em_andamento','concluida','cancelada') DEFAULT 'agendada',
  cpf CHAR(11) NOT NULL,
  id_ponto INT NOT NULL,
  CONSTRAINT fk_coleta_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_coleta_ponto FOREIGN KEY (id_ponto) REFERENCES ponto_coleta(id_ponto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: coleta_residuo (associativa M:N)
CREATE TABLE coleta_residuo (
  id_coleta INT NOT NULL,
  id_residuo INT NOT NULL,
  peso_coletado DECIMAL(10,3),
  quantidade INT DEFAULT 1,
  PRIMARY KEY (id_coleta, id_residuo),
  CONSTRAINT fk_cr_coleta FOREIGN KEY (id_coleta) REFERENCES coleta(id_coleta) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cr_residuo FOREIGN KEY (id_residuo) REFERENCES residuo(id_residuo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela: pessoa_recompensa (histórico M:N Pessoa <-> Recompensa)
CREATE TABLE pessoa_recompensa (
  id_historico INT AUTO_INCREMENT PRIMARY KEY,
  cpf CHAR(11) NOT NULL,
  id_recompensa INT NOT NULL,
  data_concessao DATETIME DEFAULT CURRENT_TIMESTAMP,
  valor_utilizado DECIMAL(10,2),
  observacao VARCHAR(255),
  CONSTRAINT fk_pr_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pr_recompensa FOREIGN KEY (id_recompensa) REFERENCES recompensa(id_recompensa) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices úteis
CREATE INDEX idx_residuo_tipo ON residuo(id_tipo);
CREATE INDEX idx_residuo_coop ON residuo(id_coop);
CREATE INDEX idx_coleta_status ON coleta(status);
CREATE INDEX idx_coleta_data ON coleta(data);

-- ---------------------
-- Dados de exemplo
-- ---------------------

INSERT INTO tipo_residuo (id_tipo, nome, descricao) VALUES
(1,'Plástico','Plásticos em geral (PET, PE, etc.)'),
(2,'Vidro','Vidro (garrafas, frascos)'),
(3,'Papel','Papel/cartão'),
(4,'Metal','Metais (latas, alumínio)'),
(5,'Eletrônico','Resíduos elétricos/electrônicos'),
(6,'Orgânico','Resíduo orgânico'),
(7,'Perigoso','Resíduos perigosos (químicos)');

INSERT INTO pessoa (cpf, nome, endereco_rua, endereco_numero, endereco_bairro, endereco_cidade, endereco_uf, data_nascimento, telefone, email) VALUES
('11122233344','Mariana Silva','Rua A','123','Centro','CidadeX','SP','1995-04-10','11999990000','mariana@example.com'),
('22233344455','Carlos Souza','Av. B','456','Jardim','CidadeY','SP','1988-11-01','11988880000','carlos@example.com');

INSERT INTO empresa (cnpj, razao_social, area_atuacao) VALUES
('11222333000181','Indústria Alfa LTDA','Embalagens Plásticas'),
('22333444000172','Fábrica Beta SA','Componentes Eletrônicos');

INSERT INTO cooperativa (id_coop, nome, endereco_rua, endereco_numero, endereco_bairro, endereco_cidade, endereco_uf, capacidade_processamento) VALUES
(1,'CoopReciclo','Rua Coop','10','Centro','CidadeX','SP',5000),
(2,'ReciclaMais','Av. Verde','200','Vila','CidadeY','SP',3000);

INSERT INTO ponto_coleta (id_ponto, localizacao, capacidade) VALUES
(1,'Praça Central - Caixa Azul',100),
(2,'Supermercado X - Entrada',200),
(3,'Mercado Y - Estacionamento',150);

INSERT INTO recompensa (id_recompensa, tipo, valor) VALUES
(1,'Cupom Desconto Loja Parceira',50.00),
(2,'Vale-transporte (por pontos)',10.00),
(3,'Doação a ONG (R$ por kg)',5.00);

-- tipos aceitos por pontos
INSERT INTO ponto_coleta_aceita (id_ponto, id_tipo) VALUES
(1,1),(1,2),(1,3),(2,1),(2,4),(3,3),(3,5);

-- resíduos (alguns vinculados a empresa, outros a cooperativa)
INSERT INTO residuo (id_residuo, id_tipo, peso, data_registro, id_coop, cnpj_empresa) VALUES
(1,1,2.350,'2025-05-01 09:10:00',NULL,'11222333000181'),
(2,3,0.500,'2025-05-02 12:00:00',1,NULL),
(3,5,1.700,'2025-05-03 15:30:00',NULL,'22333444000172'),
(4,7,0.200,'2025-05-04 08:00:00',2,NULL);

-- material especial (especialização de resíduos)
INSERT INTO material_especial (id_residuo, tipo_especial, cuidado_armazenamento) VALUES
(3,'Eletrônico','Guardar em caixa seca e encaminhar para tratamento de RAEE'),
(4,'Químico','Manter frasco lacrado e identificar periculosidade');

-- coletas
INSERT INTO coleta (id_coleta, data, status, cpf, id_ponto) VALUES
(1,'2025-05-05 10:00:00','concluida','11122233344',1),
(2,'2025-05-06 14:30:00','agendada','22233344455',2);

-- detalhe de coletas (associação Residuo <-> Coleta)
INSERT INTO coleta_residuo (id_coleta, id_residuo, peso_coletado, quantidade) VALUES
(1,1,2.350,1),
(1,2,0.500,1),
(2,3,1.700,1);

-- histórico de recompensas
INSERT INTO pessoa_recompensa (cpf, id_recompensa, data_concessao, valor_utilizado, observacao) VALUES
('11122233344',1,'2025-05-06 11:00:00',50.00,'Cupom trocado por 50'),
('22233344455',3,'2025-05-07 09:00:00',8.50,'Doação convertida');

