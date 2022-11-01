52- type -> importante. Define que tipo de teste estamos a fazer. 
	A-Para scatter plots :
		1= n_capacidade a variar
		2= n_vertices a variar
		3= p_value a variar
		
	B-Para 3d plots:
		1= analisar impacto da dupla(vertices, p)
		2= analisar impacto da dupla(capacidade, p)
		3= analisar impacto da dupla(vertices, capacidade)

53- n_vertices = valor de vertices a fixar
54- p_value = valor p a fixar
55- capacity = valor de capacidade a fixar

53,54,55 só são necessarios em gráficos em que o seu valor tem de ser fixo assim são necessarios para:
	A1 - 53, 54
	A2 - 54, 55
	A3 - 53, 55
	B1 - 55
	B2 - 53
	B3 - 54
(sao 3 da manha posso me ter baralhado mas acho que é isto xd)

57,58,59 sao os valores do tamanho de casos teste de cada. Descomentar se estiver comentado e apagar os valores nao comentados. Se adicionarem testes (tipo adicionam experiencias com o valor de 520 vertices) incrementem isto senao da merda nos scatter plots.
(ALEXY: já descomentei e tá apropriada ao que temos)

70, tipo de grafico para grafico 3d (EK, Dinic, MPM)

66- numero de vezes que uma experiencia corre deixar a 5
68- nao mexer

nos plots podem alterar definicoes tranquilamente. 

TEM DE DAR FIX NO FACTO DE O EK MANDAR VALORES A 0. O RODAS PROVAVELMENTE VAI TER DE CORRER ALGUNS TESTES ESPECIFICOS
PARA O EK ATE ELE SAIR DA TELA NOS SCATTER PLOTS. NOS GRAFICOS 3D N SEI COMO VAO FAZER TALVEZ CORTEM SÓ TODOS OS VALORES = 0 ISSO DEVE TAR ALGURES NA NET COMO FAZER.





-Para ativarem o scatter plots metam showScatter (185) a TRUE. Msm para os 3D plots
