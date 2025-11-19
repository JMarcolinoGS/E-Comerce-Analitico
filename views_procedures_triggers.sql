-- views_procedures_triggers.sql
USE ecommerce_analytics;

-- VIEW: vendas_por_mes
DROP VIEW IF EXISTS vendas_por_mes;
CREATE VIEW vendas_por_mes AS
SELECT DATE_FORMAT(p.data_pedido, '%Y-%m') AS mes,
       SUM(p.valor_total) AS total_vendas,
       COUNT(p.id_pedido) AS total_pedidos
FROM pedidos p
GROUP BY mes
ORDER BY mes;

-- VIEW: produtos_mais_vendidos
DROP VIEW IF EXISTS produtos_mais_vendidos;
CREATE VIEW produtos_mais_vendidos AS
SELECT pr.id_produto, pr.nome, pr.categoria, SUM(i.quantidade) AS total_vendido
FROM itens_pedido i
JOIN produtos pr ON pr.id_produto = i.id_produto
GROUP BY pr.id_produto, pr.nome, pr.categoria
ORDER BY total_vendido DESC;

-- PROCEDURE: registrar_entrada (atualiza estoque e cria log)
DROP PROCEDURE IF EXISTS registrar_entrada;
DELIMITER //
CREATE PROCEDURE registrar_entrada(IN p_id_produto INT, IN p_qtd INT, IN p_desc VARCHAR(255))
BEGIN
    START TRANSACTION;
        UPDATE produtos
        SET estoque = estoque + p_qtd
        WHERE id_produto = p_id_produto;
        INSERT INTO log_estoque (id_produto, acao, quantidade, descricao) VALUES (p_id_produto, 'entrada', p_qtd, p_desc);
    COMMIT;
END //
DELIMITER ;

-- PROCEDURE: registrar_saida (verifica estoque, atualiza e loga)
DROP PROCEDURE IF EXISTS registrar_saida;
DELIMITER //
CREATE PROCEDURE registrar_saida(IN p_id_produto INT, IN p_qtd INT, IN p_desc VARCHAR(255))
BEGIN
    DECLARE v_estoque INT;
    SELECT estoque INTO v_estoque FROM produtos WHERE id_produto = p_id_produto FOR UPDATE;
    IF v_estoque IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto nao encontrado';
    ELSEIF v_estoque < p_qtd THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    ELSE
        START TRANSACTION;
            UPDATE produtos SET estoque = estoque - p_qtd WHERE id_produto = p_id_produto;
            INSERT INTO log_estoque (id_produto, acao, quantidade, descricao) VALUES (p_id_produto, 'saida', p_qtd, p_desc);
        COMMIT;
    END IF;
END //
DELIMITER ;

-- TRIGGER: ao inserir item_pedido, debitar estoque automaticamente e logar (basic)
DROP TRIGGER IF EXISTS trg_debitar_estoque;
DELIMITER //
CREATE TRIGGER trg_debitar_estoque
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    -- Tenta debitar estoque; se insuficiente, pode causar erro ao usar procedure
    CALL registrar_saida(NEW.id_produto, NEW.quantidade, CONCAT('Venda (pedido ', NEW.id_pedido, ')'));
END //
DELIMITER ;

-- TRIGGER: ao deletar item_pedido, reverter estoque (caso necessário)
DROP TRIGGER IF EXISTS trg_repor_estoque_deletar_item;
DELIMITER //
CREATE TRIGGER trg_repor_estoque_deletar_item
AFTER DELETE ON itens_pedido
FOR EACH ROW
BEGIN
    CALL registrar_entrada(OLD.id_produto, OLD.quantidade, CONCAT('Reversao (item ', OLD.id_item, ')'));
END //
DELIMITER ;
