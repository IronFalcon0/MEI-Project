library(abind)
library(ggplot2)

filename = "../data/resAll.csv"

dataset = read.csv(filename, header = TRUE, sep = ",", dec = ".")

step = 10
amount_algorithms = 3

#print(dataset)

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
n_vertices = 500;
p_value = 0.37;
capacity = 210;

n_vertices_array_size = 7 
p_array_size = 8
capacity_array_size = 9 


number_test = 5
arr_dim = dim(global_array)
amount = 0;



if(type == 1){
  x = c(10, 20, 30, 50, 80, 130, 210, 340, 500)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))
  dinic_array  <- array(numeric(),c(number_test,0))   
  
}else if(type == 2){
  x = c(100, 200, 300, 500, 800, 1300, 2100)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))   
  dinic_array  <- array(numeric(),c(number_test,0))   
}else{
  x = c(0.1, 0.15, 0.2, 0.25, 0.37, 0.5, 0.75, 1)
  mpm_array <- array(numeric(),c(number_test,0))   
  ek_array  <- array(numeric(),c(number_test,0))   
  dinic_array  <- array(numeric(),c(number_test,0))   
}


i_mpm = 1
i_ek = 1
i_dinic = 1



#Capacidade fixo
if(type == 1){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[3,j,i] == p_value && global_array[4,j,i] == n_vertices){
        
        if(global_array[2,j,i] == "MPM"){
          aux <-global_array[6:10,j,i]
          mpm_array <- abind(mpm_array,aux) 
          #i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          print(global_array[6:10,j,i])
          aux <-global_array[6:10,j,i]
          ek_array <- abind(ek_array,aux) 
          #i_ek <- i_ek + 1
        }
        else{
          dinic_array <- abind(dinic_array,global_array[6:10,j,i]) 
          #i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}else if(type == 2){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[3,j,i] == p_value && global_array[5,j,i] == capacity){

        if(global_array[2,j,i] == "MPM"){
          mpm_array <- abind(mpm_array,global_array[6:10,j,i]) 
          #i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array <- abind(ek_array,global_array[6:10,j,i]) 
          #i_ek <- i_ek + 1
        }
        else{
          dinic_array <- abind(dinic_array,global_array[6:10,j,i]) 
          #i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}else if(type == 3){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[4,j,i] == n_vertices && global_array[5,j,i] == capacity){
        if(global_array[2,j,i] == "MPM"){
          mpm_array <- abind(mpm_array,global_array[6:10,j,i]) 
          #i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array <- abind(ek_array,global_array[6:10,j,i]) 
          #i_ek <- i_ek + 1
        }
        else{
          dinic_array <- abind(dinic_array,global_array[6:10,j,i]) 
          #i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}






print(dinic_array)
print(mpm_array)
print(ek_array)



#Scatter Plot
b = data.frame(dinic_array)
print(b)

p <- ggplot(dsmall, aes(carat, price, color=color)) + geom_point(size=4)



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
