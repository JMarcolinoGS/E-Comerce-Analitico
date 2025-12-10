UPDATE pedidos p
JOIN (
    SELECT id_pedido, SUM(quantidade * preco_unitario) AS soma
    FROM itens_pedido
    GROUP BY id_pedido
) s ON p.id_pedido = s.id_pedido
SET p.valor_total = s.soma;

-- indices_and_security.sql
USE eccomerce_annalyctics;

-- Índices úteis para performance
CREATE INDEX idx_produtos_categoria ON produtos (categoria);
CREATE INDEX idx_produtos_estoque ON produtos (estoque);
CREATE INDEX idx_clientes_email ON clientes (email);
CREATE INDEX idx_pedidos_data ON pedidos (data_pedido);
CREATE INDEX idx_itens_pedido_idpedido ON itens_pedido (id_pedido);

