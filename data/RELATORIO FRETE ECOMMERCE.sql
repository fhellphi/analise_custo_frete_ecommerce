SELECT 

A.NF_NUMERO,
CONVERT (VARCHAR(10), A.EMISSAO, 1) AS DATA_FATURAMENTO,
A.VALOR_TOTAL_ITENS,
A.SERIE_NF,

CASE
 
    WHEN A.SERIE_NF = '086' AND A.NATUREZA_OPERACAO_CODIGO in('6108EC', '5102EC', '5.102', '6.102')  THEN 'VENDA'
	WHEN A.SERIE_NF = '10' AND A.NATUREZA_OPERACAO_CODIGO in('6108EC', '5102EC', '5.102', '6.102')  THEN 'VENDA'
	WHEN A.SERIE_NF = '085' AND A.NATUREZA_OPERACAO_CODIGO in ('6108EC', '5102EC') THEN 'VENDA'
    WHEN A.SERIE_NF = '30' AND A.NATUREZA_OPERACAO_CODIGO IN ('1202EC', '2202EC', '2.202') THEN 'DEVOLUCAO'
	WHEN A.SERIE_NF = '085' AND A.NATUREZA_OPERACAO_CODIGO in ('1202EC', '2202EC') THEN 'DEVOLUCAO'

  
    WHEN A.NATUREZA_OPERACAO_CODIGO IN ('5102EC', '5.102', '6.102') THEN 'VENDA'


    WHEN A.NATUREZA_OPERACAO_CODIGO IN ('1202EC', '2202EC', '2.202') THEN 'DEVOLUCAO'

END AS TIPO_PEDIDO,

	CASE
		WHEN A.SERIE_NF = '085' THEN 'MILLENIUM'
		WHEN A.SERIE_NF = '10' THEN 'SINTESE'
		WHEN A.SERIE_NF = '30' THEN 'SINTESE'
		WHEN A.SERIE_NF = '086' THEN 'SINTESE'
	END AS PLATAFORMA_ORIGEM,

D.FILIAL AS FILIAL_FATURADA,
A.FRETE AS FRETE_PAGO_CLIENTE,
A.PESO_LIQUIDO,
A.PESO_BRUTO,
A.CODIGO_CLIENTE,
D.FILIAL,
B.PEDIDO_SITE,
B.PEDIDO,
C.PRODUTO,
C.COR_PRODUTO,
C.TAMANHO,


	CASE
		WHEN D.FILIAL = 'CD - VAR - E-COMMERCE/SP ' THEN 'CORREIOS'
		ELSE B.TRANSPORTADORA
	END AS TRANSPORTADORA ,

	CASE
		WHEN B.FORMA_ENVIO = '' OR B.FORMA_ENVIO IS NULL THEN 'SEM INFORMAÇÃO DA FORMA DE ENVIO'
		ELSE B.FORMA_ENVIO
	END AS OPERACAO_TRANSPORTADORA,


E.ENDERECO AS ENDERECO_CLIENTE,
E.CEP AS CEP_CLIENTE,
E.CIDADE AS CIDADE_CLIENTE,
F.UF AS UF_LOJA,
E.UF AS UF_CLIENTE


FROM 
	LOJA_NOTA_FISCAL AS A 
	
	JOIN LOJA_PEDIDO AS B
	ON A.CODIGO_CLIENTE = B.CODIGO_CLIENTE
	AND  A.CODIGO_FILIAL = B.CODIGO_FILIAL_ORIGEM
	AND A.VALOR_TOTAL_ITENS = B.VALOR_TOTAL

	JOIN LOJA_PEDIDO_PRODUTO AS C 
	ON B.CODIGO_FILIAL_ORIGEM = C.CODIGO_FILIAL_ORIGEM
	AND B.PEDIDO = C.PEDIDO
	AND A.CODIGO_FILIAL = C.CODIGO_FILIAL_ORIGEM

	JOIN LOJAS_VAREJO AS D
	ON A.CODIGO_FILIAL = D.CODIGO_FILIAL

	 JOIN CLIENTES_VAREJO AS E
	ON E.CODIGO_CLIENTE = A.CODIGO_CLIENTE

	JOIN CADASTRO_CLI_FOR AS F
	ON D.FILIAL = F.NOME_CLIFOR


	

WHERE NOT(
	A.SERIE_NF = '086' AND A.NATUREZA_OPERACAO_CODIGO IN ('1202EC', '2202EC', '2.202')
) 
	AND A.EMISSAO >= '20250101'
	AND A.SERIE_NF IN ('30', '086', '085', '10')
	AND B.PEDIDO_SITE <> ''
	AND B.ENTREGUE = 1
	AND A.NATUREZA_OPERACAO_CODIGO IN ('5102EC', '6108EC', '2202EC', '1202EC', '2.202', '6.102', '5.102','2.202')

