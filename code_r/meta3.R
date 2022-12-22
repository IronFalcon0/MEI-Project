meta3 <- function(){
  
  
  f1 = "../data/dataD3.in"
  f2 = "../data/dataD3_avg.in"
  f3 = "../data/dataD3_2.in"
  f4 = "../data/dataD3_2_avg.in"
  f5 = "../data/dataD3_3_Dinic.in"
  f6 = "../data/dataD3_3_MPM.in"
  f7 = "../data/dataD3_3_EK.in"
  
  #Para provar primeira hipotese ("MPM’s and Dinic’s times, in relation to the number of vertices, follow the same distribution.") usamos uma
  #MANOVA
  #df= read.table(f1, header=TRUE)
  
  #manova.out <- aov(time ~ as.factor(algorithm) + Error(group), data = df)
  #summary(manova.out)
  
  #Verficamos as assunções
  #plot(manova.out) não funciona logo fomos ver o qq plot
  #qqnorm(residuals(manova.out$Within))
  #qqline(residuals(manova.out$Within))
  
  #df2 = read.table(f2, header=TRUE)
  #As assunções falham logo usaremos kruskal wallis
  #kruskal.test(time ~ as.factor(algorithm), data=df2)
  
  
  
  
  #Para provar segunda hipotese ("All the algorithms’ times, in relation to the connection probability, follow the same distribution.") usamos
  #uma MANOVA
  
  #df3= read.table(f3, header=TRUE)
  
  #manova2.out <- aov(time ~ as.factor(algorithm) + Error(group), data = df3)
  #summary(manova2.out)
  
  #Verficamos as assunções
  #plot(manova2.out) 
  #qqnorm(residuals(manova2.out$Within))
  #qqline(residuals(manova2.out$Within))
  
  #As assunções falham logo usaremos kruskal wallis
  #df4 = read.table(f4, header=TRUE)
  #kruskal.test(time ~ as.factor(algorithm), data=df4)
  #pairwise.wilcox.test(df4$time, g = df4$algorithm, p.adjust.method="holm")
  
  
  
  #Para provar a terceira hipotese ("The arc capacity affects the algorithms’ performance.") usamos uma one way anova
  df5 = read.table(f5, header=TRUE)
  df6 = read.table(f6, header=TRUE)
  df7 = read.table(f7, header=TRUE)
  
  aov_dinic.out <- aov(time ~ cap , data = df5)
  aov_mpm.out <- aov(time ~ cap , data = df6)
  aov_ek.out <- aov(time ~ cap , data = df7)
  
  print(summary(aov_ek.out))
  plot(aov_ek.out)
}