-- insert_data.sql
USE ecommerce_analytics;

-- Clientes (10)
INSERT INTO clientes (nome, email, cidade, estado) VALUES
('João Marcolino', 'joao.marcolino@email.com', 'São Paulo', 'SP'),
('Ana Souza', 'ana.souza@email.com', 'Recife', 'PE'),
('Pedro Lima', 'pedro.lima@email.com', 'Curitiba', 'PR'),
('Luiza Oliveira', 'luiza.oliveira@email.com', 'Salvador', 'BA'),
('Carlos Mendes', 'carlos.mendes@email.com', 'Belo Horizonte', 'MG'),
('Mariana Castro', 'mariana.castro@email.com', 'Fortaleza', 'CE'),
('Rafael Santos', 'rafael.santos@email.com', 'Porto Alegre', 'RS'),
('Beatriz Rocha', 'beatriz.rocha@email.com', 'Brasília', 'DF'),
('Daniel Almeida', 'daniel.almeida@email.com', 'Goiânia', 'GO'),
('Fernanda Pinto', 'fernanda.pinto@email.com', 'Manaus', 'AM');

-- Produtos (10)
INSERT INTO produtos (nome, categoria, preco, estoque) VALUES
('Fone Bluetooth JBL', 'Eletrônicos', 199.90, 50),
('Camisa Polo Azul', 'Vestuário', 89.90, 100),
('Teclado Mecânico RGB', 'Eletrônicos', 349.00, 30),
('Relógio Digital', 'Acessórios', 129.00, 70),
('Mouse Gamer', 'Eletrônicos', 159.90, 40),
('Boné Esportivo', 'Vestuário', 59.90, 80),
('Caixa de Som Portátil', 'Eletrônicos', 249.90, 25),
('Caneca Personalizada', 'Casa', 39.90, 150),
('Mochila Executiva', 'Acessórios', 189.90, 45),
('Camiseta Branca Básica', 'Vestuário', 39.90, 200);

-- Pedidos (12) - id_cliente entre 1 e 10
INSERT INTO pedidos (id_cliente, data_pedido, valor_total, status_pedido) VALUES
(1, '2025-10-01', 548.90, 'Concluído'),
(2, '2025-10-03', 159.90, 'Concluído'),
(3, '2025-10-05', 89.90, 'Concluído'),
(4, '2025-10-07', 508.70, 'Concluído'),
(5, '2025-10-08', 199.90, 'Concluído'),
(1, '2025-10-10', 229.80, 'Concluído'),
(6, '2025-10-12', 379.80, 'Concluído'),
(7, '2025-10-15', 129.00, 'Pendente'),
(8, '2025-10-18', 189.90, 'Concluído'),
(9, '2025-10-20', 399.80, 'Concluído'),
(10, '2025-10-22', 79.80, 'Concluído'),
(2, '2025-10-25', 289.80, 'Concluído');

-- Itens_pedido (cada pedido 1-4 itens)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 199.90),
(1, 3, 1, 349.00),
(2, 5, 1, 159.90),
(3, 2, 1, 89.90),
(4, 1, 1, 199.90),
(4, 4, 1, 129.00),
(4, 6, 3, 59.90),
(5, 1, 1, 199.90),
(6, 8, 2, 39.90),
(6, 10, 1, 149.99), -- exemplo preço arredondado (pode ajustar)
(7, 3, 1, 349.00),
(7, 6, 1, 59.90),
(8, 4, 1, 129.00),
(9, 9, 1, 189.90),
(10, 5, 2, 159.90),
(11, 8, 2, 39.90),
(12, 3, 1, 349.00),
(12, 6, 1, 59.90);

-- Pagamentos (um por pedido, alguns pendentes)
INSERT INTO pagamentos (id_pedido, forma_pagamento, status, data_pagamento) VALUES
(1, 'Cartão de Crédito', 'Pago', '2025-10-02'),
(2, 'Pix', 'Pago', '2025-10-03'),
(3, 'Boleto', 'Pago', '2025-10-06'),
(4, 'Cartão de Crédito', 'Pago', '2025-10-08'),
(5, 'Pix', 'Pago', '2025-10-09'),
(6, 'Cartão de Crédito', 'Pago', '2025-10-11'),
(7, 'Pix', 'Pago', '2025-10-13'),
(8, 'Boleto', 'Pendente', NULL),
(9, 'Cartão de Crédito', 'Pago', '2025-10-19'),
(10, 'Pix', 'Pago', '2025-10-21'),
(11, 'Boleto', 'Pago', '2025-10-23'),
(12, 'Cartão de Crédito', 'Pago', '2025-10-26');
