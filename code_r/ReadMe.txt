

META 1:


linha2 = true
	Linha 52
	Alterar valores para gerar scatter plots e 3D plots. TRUE para ativar um plot, FALSE para desativar.

		A - Para scatter plots :
			1 = n_capacidade a variar
			2 = n_vertices a variar
			3 = p_value a variar

		B - Para 3d plots:
			1 = analisar impacto da dupla(vertices, p)
			2 = analisar impacto da dupla(capacidade, p)
			3 = analisar impacto da dupla(vertices, capacidade)

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

	70, tipo de grafico para grafico 3d (EK, Dinic, MPM)
	
	
META 3:

