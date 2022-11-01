
library(abind)
library(ggplot2)
library(ggpubr)
library(ggpmisc)
#install.packages("scatterplot3d") # Install
library("scatterplot3d") # load

filename = "../data/resAllL.csv"

library( rgl )
library(magick)
library("plot3D")






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
type = 1; 
n_vertices = 1000;
p_value = 0.4;
capacity = 500;
show3D = TRUE
showScatter = FALSE
plot_type = "Dinic" # 1) EK 2) MPM 3) Dinic (atenção aos upper e lower cases)
n_vertices_cap = 1600 # discards info of graphs larger than n, only applies for type 1 and 3

p_array_size = 11
n_vertices_array_size = 27 
capacity_array_size = 9 

# n_vertices_array_size = 7 
# p_array_size = 8
# capacity_array_size = 9 


number_test = 5
arr_dim = dim(global_array)
amount = 0;

if(type == 1){
  amount = capacity_array_size
  string = "capacity"

  x = c(10, 20, 30, 50, 80, 130, 210, 340, 500)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))
  dinic_array  <- array(numeric(),c(number_test,0))   
  values_vertices = c()
  values_p = c()
  times = c()
  
}else if(type == 2){
  string = "number vertices"
  amount = n_vertices_array_size

  x = c(100, 150, 200, 250, 300, 350, 400, 450, 500, 600, 700, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2300, 2600, 2900, 3200, 3500, 4000, 4500, 5000, 5500)

  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))   
  dinic_array  <- array(numeric(),c(number_test,0)) 
  values_capacity = c()
  values_p = c()
  times = c()
}else{
  string = "p_value"
  amount = p_array_size

  x = c(0.12, 0.15, 0.2, 0.25, 0.30, 0.35, 0.4, 0.5, 0.6, 0.8, 1)

  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))   
  dinic_array  <- array(numeric(),c(number_test,0))   
  values_vertices = c()
  values_capacity = c()
  times = c()
}



#Capacidade fixo
if(type == 1){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(as.numeric(global_array[4,j,i]) > n_vertices_cap) {
        next
      }
        
      if(global_array[5,j,i] == capacity && plot_type ==global_array[2,j,i] ){
        values_vertices <- c(values_vertices,rep( as.numeric(global_array[4,j,i]),number_test))
        values_p <- c(values_p,rep( as.numeric(global_array[3,j,i]),number_test))
        times <- c(times,  as.numeric(global_array[6:10,j,i]))
        
      }
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
      
      if(global_array[4,j,i] == n_vertices && plot_type ==global_array[2,j,i] ){
        values_capacity <- c(values_capacity,rep( as.numeric(global_array[5,j,i]),number_test))
        values_p <- c(values_p,rep( as.numeric(global_array[3,j,i]),number_test))
        times <- c(times,  as.numeric(global_array[6:10,j,i]))
      }
      
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
      if(as.numeric(global_array[4,j,i]) > n_vertices_cap) {
        next
      }
      
      if(global_array[3,j,i] == p_value && plot_type ==global_array[2,j,i] ){
        values_capacity <- c(values_capacity,rep( as.numeric(global_array[5,j,i]),number_test))
        values_vertices <- c(values_vertices,rep( as.numeric(global_array[4,j,i]),number_test))
        times <- c(times,  as.numeric(global_array[6:10,j,i]))
      }
      
      if(global_array[4,j,i] == n_vertices && global_array[5,j,i] == capacity){
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
}


print(dinic_array)
print(mpm_array)
print(ek_array)


if(showScatter){
  
  dinic_avg = colMeans(dinic_array)
  mpm_avg = colMeans(mpm_array)
  ek_avg = colMeans(ek_array)
  
  
  #Scatter Plot
  print(c(dinic_avg,mpm_avg, ek_avg))
  
  print(x)
  df = data.frame(x,c(dinic_avg,mpm_avg, ek_avg))
  #df = data.frame(x,c(dinic_avg,mpm_avg))
  colnames(df) <- c('x','y')
  df$group <- factor(c(rep(c("Dinic"), amount),rep(c("Mpm"), amount),rep(c("Ek"), amount )))
  #df$group <- factor(c(rep(c("Dinic"), amount),rep(c("Mpm"), amount)))
  #type = 1
  print(df)
  
  
  #m <- lm(y ~ x, b);
  if(type == 1){
    yub = 1
    ylb = 0
    p <- ggplot(data = df, aes(x = x, y = y, colour = group)) +
      stat_poly_line(formula = y ~ poly(x, 1, raw = TRUE)) +
      stat_poly_eq(formula = y ~ poly(x, 1, raw = TRUE),
                   aes(label = paste(after_stat(eq.label), after_stat(rr.label), sep = "*\", \"*")))+
      
      geom_point() + ylim(ylb,yub)+
      labs(title="Capacity Evolution",
           x = string, y = "Time(s)")
    
    print(p)
    
  }
  
  if(type == 2 || type == 3){
    yub = 0.1
    ylb = 0
  p <- ggplot(data = df, aes(x = x, y = y, colour = group)) +
    stat_poly_line(formula = y ~ poly(x, 2, raw = TRUE)) +
    stat_poly_eq(formula = y ~ poly(x, 2, raw = TRUE),
                 aes(label = paste(after_stat(eq.label), after_stat(rr.label), sep = "*\", \"*")))+
    
    geom_point() + ylim(ylb,yub)+
    labs(title="Number Vertices Evolution",
                                  x = string, y = "Time(s)")
  
  print(p)
  }
}

#3D graph


if(show3D){
  if(type == 1){
    df = data.frame(values_p,values_vertices, times)
    
    print(times)
  
    x <- df$values_p
    y <- df$values_vertices
    z <- df$times
    
    #ONLY GOD KNOWS HOW THIS WORKS!!!!!!!!!!!!!
    fit <- lm(z ~ x + y)
    # predict values on regular xy grid
    grid.lines = 26
    x.pred <- seq(min(x), max(x), length.out = grid.lines)
    y.pred <- seq(min(y), max(y), length.out = grid.lines)
    xy <- expand.grid( x = x.pred, y = y.pred)
    z.pred <- matrix(predict(fit, newdata = xy), 
                     nrow = grid.lines, ncol = grid.lines)
    
    fitpoints <- predict(fit)
    
    scatter3D(x,y,z, pch = 16, theta = 50,phi = 0, bty = "g",main = paste(plot_type," data"), xlab = "Probability",
              ylab ="Number Vertices", zlab = "time", clab = c("Time(s)")
              ,ticktype = "detailed", surf = list(x = x.pred, y = y.pred, z = z.pred,  
                                                  facets = NA, fit = fitpoints))
    
  }
  if(type == 2){
    print(values_p)
    df = data.frame(values_p,values_capacity, times)
    print(df)
    x <- df$values_p
    y <- df$values_capacity
    z <- df$times
    
    
    #ONLY GOD KNOWS HOW THIS WORKS!!!!!!!!!!!!!
    fit <- lm(z ~ x + y)
    # predict values on regular xy grid
    grid.lines = 26
    x.pred <- seq(min(x), max(x), length.out = grid.lines)
    y.pred <- seq(min(y), max(y), length.out = grid.lines)
    xy <- expand.grid( x = x.pred, y = y.pred)
    z.pred <- matrix(predict(fit, newdata = xy), 
                     nrow = grid.lines, ncol = grid.lines)
    
    fitpoints <- predict(fit)
    scatter3D(x,y,z, pch = 16, theta = 50,phi = 0, bty = "g",main = paste(plot_type," data"), xlab = "Probability",
              ylab ="Capacity", zlab = "time", clab = c("Time(s)")
              ,ticktype = "detailed", surf = list(x = x.pred, y = y.pred, z = z.pred,  
                                                    facets = NA, fit = fitpoints))
  }
  if(type == 3){
    df = data.frame(values_capacity,values_vertices, times)
    
    x <- df$values_capacity
    y <- df$values_vertices
    z <- df$times
    
    
    #ONLY GOD KNOWS HOW THIS WORKS!!!!!!!!!!!!!
    fit <- lm(z ~ x + y)
    # predict values on regular xy grid
    grid.lines = 26
    x.pred <- seq(min(x), max(x), length.out = grid.lines)
    y.pred <- seq(min(y), max(y), length.out = grid.lines)
    xy <- expand.grid( x = x.pred, y = y.pred)
    z.pred <- matrix(predict(fit, newdata = xy), 
                     nrow = grid.lines, ncol = grid.lines)
    
    fitpoints <- predict(fit)
    
    scatter3D(x,y,z, pch = 16, theta = 50,phi = 0, bty = "g",main = paste(plot_type," data"), xlab = "capacity",
              ylab ="vertices", zlab = "time", clab = c("Time(s)")
              ,ticktype = "detailed", surf = list(x = x.pred, y = y.pred, z = z.pred,  
                                                  facets = NA, fit = fitpoints))
    
  }
}
