
library(abind)
library(ggplot2)
library(ggpubr)
library(ggpmisc)

filename = "../data/resAll.csv"






dataset = read.csv(filename, header = TRUE, sep = ",", dec = ".")

step = 10
amount_algorithms = 3


global_array <- array(numeric(),c(step,amount_algorithms,0)) 

for(i in seq(from = 0, to = nrow(dataset)-1, by = amount_algorithms)){
  test_array = array(numeric(),c(step,0))    
  
  for(k in 1:amount_algorithms){
    
    algorithm_array <- rep(NA,step)
    
    for(j in 1:step){
      
      algorithm_array[j] = dataset[i+k,j]
    }
    
    test_array <- abind(test_array,algorithm_array)
  }
  
  global_array <- abind(global_array,test_array)
}

#print(global_array)


#Type 1 = n_capacidade a mudar
#Type 2 = n_vertices a mudar
#Type 3 = p_value a mudar
type = 2; 
n_vertices = 2100;
p_value = 0.37;
capacity = 340;

n_vertices_array_size = 7 
p_array_size = 8
capacity_array_size = 9 


number_test = 5
arr_dim = dim(global_array)
amount = 0;



if(type == 1){
  amount = capacity_array_size
  x = c(10, 20, 30, 50, 80, 130, 210, 340, 500)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))
  dinic_array  <- array(numeric(),c(number_test,0))   
  
}else if(type == 2){
  amount = n_vertices_array_size
  x = c(100, 200, 300, 500, 800, 1300, 2100)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))   
  dinic_array  <- array(numeric(),c(number_test,0))   
}else{
  amount = p_array_size
  x = c(0.1, 0.15, 0.2, 0.25, 0.37, 0.5, 0.75, 1)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))   
  dinic_array  <- array(numeric(),c(number_test,0))   
}



#Capacidade fixo
if(type == 1){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[3,j,i] == p_value && global_array[4,j,i] == n_vertices){
        
        if(global_array[2,j,i] == "MPM"){
          mpm_array <- abind(mpm_array,as.numeric(global_array[6:10,j,i]))
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array <- abind(ek_array,as.numeric(global_array[6:10,j,i]))
        }
        else{
          dinic_array <- abind(dinic_array,as.numeric(global_array[6:10,j,i]))
        }
      }
    }
    
  }
}else if(type == 2){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[3,j,i] == p_value && global_array[5,j,i] == capacity){
        
        if(global_array[2,j,i] == "MPM"){
          mpm_array <- abind(mpm_array,as.numeric(global_array[6:10,j,i])) 
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array <- abind(ek_array,as.numeric(global_array[6:10,j,i]))
        }
        else{
          dinic_array <- abind(dinic_array,as.numeric(global_array[6:10,j,i]))
        }
      }
    }
    
  }
}else if(type == 3){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[4,j,i] == n_vertices && global_array[5,j,i] == capacity){
        if(global_array[2,j,i] == "MPM"){
          mpm_array <- abind(mpm_array,as.numeric(global_array[6:10,j,i]))
          #i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array <- abind(ek_array,as.numeric(global_array[6:10,j,i]))
          #i_ek <- i_ek + 1
        }
        else{
          dinic_array <- abind(dinic_array,as.numeric(global_array[6:10,j,i]))
          #i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}


print(dinic_array)
print(mpm_array)
print(ek_array)


dinic_avg = colMeans(dinic_array)
mpm_avg = colMeans(mpm_array)
ek_avg = colMeans(ek_array)


#Scatter Plot
print(c(dinic_avg,mpm_avg, ek_avg))


df = data.frame(x,c(dinic_avg,mpm_avg, ek_avg))
colnames(df) <- c('x','y')
df$group <- factor(c(rep(c("Dinic"), amount),rep(c("Mpm"), amount),rep(c("Ek"), amount )))

print(df)

#m <- lm(y ~ x, b);

p <- ggplot(data = df, aes(x = x, y = y, colour = group)) +
  stat_poly_line(formula = y ~ poly(x, 2, raw = TRUE)) +
  stat_poly_eq(formula = y ~ poly(x, 2, raw = TRUE),
               aes(label = paste(after_stat(eq.label), after_stat(rr.label), sep = "*\", \"*")))+
  
  geom_point() + ylim(-5,50)+
  labs(title="Fixing vertices",
                                x ="number vertices", y = "Time(s)")

print(p)

#ggplot(data = df, aes(x = x, y = y2))
#  stat_poly_line(formula = y ~poly(x, 2, raw = TRUE)) +
#  stat_poly_eq(formula = y ~ poly(x, 2, raw = TRUE),
#               aes(label = after_stat(eq.label)))


#ggplot(data = df, aes(x = x, y = y2))
#  stat_poly_line(formula = y ~poly(x, 2, raw = TRUE)) +
#  stat_poly_eq(formula = y ~ poly(x, 2, raw = TRUE),
#                 aes(label = after_stat(eq.label)))+
#  geom_point()



#p <- ggplot(b) +geom_jitter(aes(x,dinic_avg),colour="red")+
#  geom_smooth(method = "lm" ,aes(x,dinic_avg,col="dinic"), formula= (y ~ x + I(x^2)), se=FALSE, linetype = 1) +

#geom_jitter(aes(x,ek_avg),colour="green")+geom_smooth(method = "lm" ,aes(x,ek_avg,col="ek"), formula= (y ~ x + I(x^2)), se=FALSE, linetype = 1) +
#  geom_jitter(aes(x,mpm_avg),colour="blue")+geom_smooth(method = "lm" ,aes(x,mpm_avg,col="mpm"), formula= (y ~ x + I(x^2)), se=FALSE, linetype = 1)

#p1 <- p +geom_text(x=500,y = 0.6, label= lm_eqn(b), parse = TRUE)
#print(p1)


#Q-q plot



#Bar plot with error bars




#Density Plot with Area Coloring??


#p <- ggplot(b, aes(color, /carat, fill=color)) + geom_boxplot()
#print(p)


#print(c[3])

#run = c(1,2,3,4,5)


#global_array[3:dim(global_array)[1],1,1] = c(1,2,3,4,5)
#b = data.frame(global_array[3:dim(global_array)[1],1,1])

#print(b)
#model <- lm(y~x, data=b)
#summary(model)
#g <- ggplot(b, aes(c(1,2,3,4,5),X1)) + geom_point() + geom_smooth(method="lm") + theme(panel.background=element_rect(fill = "white", colour = "black"))
#print(g)
#for (i in 1:dim(global_array)[3]) {
#  
#}
