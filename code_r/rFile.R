library(abind)
library(ggplot2)

filename = "../data/resP0.1.csv"

dataset = read.csv(filename, header = TRUE, sep = ",", dec = ".")

step = 6
amount_algorithms = 3

print(dataset)

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

print(global_array)

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
