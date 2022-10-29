





library(abind)
library(ggplot2)

filename = "data/resP0.37.csv"

dataset = read.csv(filename, header = TRUE, sep = ",", dec = ".")

step = 6
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



#Box Plot
#Type 1 = n_capacidade a mudar
#Type 2 = n_vertices a mudar
#Type 3 = p_value a mudar
type = 2; 
n_vertices = 500;
p_value = 0.37;
capacity = 80;

n_vertices_array_size = 7 
p_array_size = 8
capacity_array_size = 9 


arr_dim = dim(global_array)
amount = 0;

if(type == 1){
  mpm_array <- rep(NA, capacity_array_size)
  ek_array  <- rep(NA, capacity_array_size)
  dinic_array  <- rep(NA, capacity_array_size)
  
}else if(type == 2){
  mpm_array <- rep(NA, n_vertices_array_size)
  ek_array  <- rep(NA, n_vertices_array_size)
  dinic_array  <- rep(NA, n_vertices_array_size)
}else{
  mpm_array <- rep(NA, p_array_size)
  ek_array  <- rep(NA, p_array_size)
  dinic_array  <- rep(NA, p_array_size)
}


i_mpm = 1
i_ek = 1
i_dinic = 1



#Capacidade fixo
if(type == 1){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[3,j,i] == p_value && global_array[4,j,i] == n_vertices){
        print(global_array[1,j,i])
        if(global_array[2,j,i] == "MPM"){
          mpm_array[i_mpm] = global_array[6,j,i]
          i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array[i_ek] = global_array[6,j,i]
          i_ek <- i_ek + 1
        }
        else{
          dinic_array[i_dinic] = global_array[6,j,i]
          i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}else if(type == 2){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[3,j,i] == p_value && global_array[5,j,i] == capacity){

        if(global_array[2,j,i] == "MPM"){
          mpm_array[i_mpm] = global_array[6,j,i]
          i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array[i_ek] = global_array[6,j,i]
          i_ek <- i_ek + 1
        }
        else{
          dinic_array[i_dinic] = global_array[6,j,i]
          i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}else if(type == 3){
  for(i in 1:arr_dim[3]){
    for(j in 1:arr_dim[2]){
      if(global_array[4,j,i] == n_vertices && global_array[5,j,i] == capacity){
        if(global_array[2,j,i] == "MPM"){
          mpm_array[i_mpm] = global_array[6,j,i]
          i_mpm <- i_mpm + 1
        }
        else if(global_array[2,j,i] == "EK"){
          ek_array[i_ek] = global_array[6,j,i]
          i_ek <- i_ek + 1
        }
        else{
          dinic_array[i_dinic] = global_array[6,j,i]
          i_dinic <- i_dinic + 1
        }
      }
    }
    
  }
}

print(dinic_array)
print(mpm_array)
print(ek_array)

#p <- ggplot(global_array, aes(color, price/carat, fill=color)) + geom_boxplot()
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
