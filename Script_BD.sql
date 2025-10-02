CREATE TABLE mtt_pais (
    cod_pais INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_pais VARCHAR(50) NOT NULL
);

CREATE TABLE mtt_estado (
    cod_estado INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_estado VARCHAR(50) NOT NULL,
    cod_pais INT,
    FOREIGN KEY (cod_pais) REFERENCES mtt_pais(cod_pais)
);

CREATE TABLE mtt_cidade (
    cod_cidade INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_cidade VARCHAR(50) NOT NULL,
    cod_estado INT,
    FOREIGN KEY (cod_estado) REFERENCES mtt_estado(cod_estado)
);

CREATE TABLE mtt_filial (
    cod_filial INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_filial VARCHAR(50) NOT NULL,
    cod_cidade INT,
    tamanho_patio NUMBER(10),
    FOREIGN KEY (cod_cidade) REFERENCES mtt_cidade(cod_cidade)
);

CREATE TABLE mtt_cliente (
    cod_cliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    cpf_cliente VARCHAR(15) NOT NULL,
    telefone_cliente VARCHAR(20)
);

CREATE TABLE mtt_moto (
    cod_moto INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    modelo VARCHAR(50),
    ano_fabricacao INT,
    categoria VARCHAR(50),
    cod_cliente INT,              
    placa VARCHAR2(8) NOT NULL,   
    CONSTRAINT uk_mtt_moto_placa UNIQUE (placa),
    FOREIGN KEY (cod_cliente) REFERENCES mtt_cliente(cod_cliente)
);

CREATE TABLE mtt_localizacao_moto (
    cod_localizacao INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cod_moto INT,
    cod_filial INT,
    box_posicao VARCHAR(20),
    status VARCHAR(20),
    data_entrada TIMESTAMP,
    data_saida TIMESTAMP,
    FOREIGN KEY (cod_moto) REFERENCES mtt_moto(cod_moto),
    FOREIGN KEY (cod_filial) REFERENCES mtt_filial(cod_filial)
);

CREATE TABLE mtt_movimento_moto (
    cod_movimento INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cod_moto INT,
    cod_filial INT,
    tipo_movimento VARCHAR(50),
    data_movimento TIMESTAMP,
    manutencao_necessaria VARCHAR(100),
    FOREIGN KEY (cod_moto) REFERENCES mtt_moto(cod_moto),
    FOREIGN KEY (cod_filial) REFERENCES mtt_filial(cod_filial)
);

CREATE TABLE mtt_manutencao_moto (
    cod_manutencao   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cod_moto         INT           NOT NULL,
    cod_filial       INT           NOT NULL,     
    tipo_manutencao  VARCHAR(100)  NOT NULL,     
    data_manutencao  TIMESTAMP     NOT NULL,
    valor_manutencao NUMBER(10,2)  NOT NULL,     
    FOREIGN KEY (cod_moto)   REFERENCES mtt_moto(cod_moto),
    FOREIGN KEY (cod_filial) REFERENCES mtt_filial(cod_filial)
);

CREATE TABLE mtt_sensor_moto (
    cod_sensor INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cod_filial INT,
    tipo_sensor VARCHAR(50),
    local_instalacao VARCHAR(100),
    cod_moto INT,
    FOREIGN KEY (cod_filial) REFERENCES mtt_filial(cod_filial),
    FOREIGN KEY (cod_moto) REFERENCES mtt_moto(cod_moto)
);

CREATE TABLE mtt_usuario (
    cod_usuario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_usuario VARCHAR(50),
    email VARCHAR(100) NOT NULL,
    tipo_acesso VARCHAR(20),
    cod_filial INT,
    funcao_usuario VARCHAR(50),
    FOREIGN KEY (cod_filial) REFERENCES mtt_filial(cod_filial)
);
