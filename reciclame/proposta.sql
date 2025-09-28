-- 1) Mostrar tabelas
CREATE DATABASE IF NOT EXISTS reciclame;

SHOW TABLES;

-- 2) listar coletas e resíduos coletados por uma pessoa
SELECT p.nome, c.id_coleta, c.data, c.status, r.id_residuo, tr.nome AS tipo_residuo, cr.peso_coletado
FROM pessoa p
JOIN coleta c ON p.cpf = c.cpf
JOIN coleta_residuo cr ON c.id_coleta = cr.id_coleta
JOIN residuo r ON cr.id_residuo = r.id_residuo
JOIN tipo_residuo tr ON r.id_tipo = tr.id_tipo
WHERE p.cpf = '11122233344';

-- 3) total de peso coletado por tipo de resíduo
SELECT tr.nome AS tipo_residuo, SUM(r.peso) AS total_kg
FROM residuo r
JOIN tipo_residuo tr ON r.id_tipo = tr.id_tipo
GROUP BY tr.nome;

-- 4) verificar tipos aceitos por cada ponto de coleta
SELECT pc.id_ponto, pc.localizacao, GROUP_CONCAT(tr.nome SEPARATOR ', ') AS tipos_aceitos
FROM ponto_coleta pc
JOIN ponto_coleta_aceita pca ON pc.id_ponto = pca.id_ponto
JOIN tipo_residuo tr ON pca.id_tipo = tr.id_tipo
GROUP BY pc.id_ponto;

-- 5) exemplo de UPDATE: marcar coleta como concluída
UPDATE coleta SET status = 'concluida' WHERE id_coleta = 2;

-- 6) exemplo de UPDATE: associar um resíduo a uma cooperativa
UPDATE residuo SET id_coop = 1 WHERE id_residuo = 3;

