# ------------------------------------------------------------------------
# graph generator for max-flow in python3
#
# command line arguments:
#   n = number of vertices
#   p = arc probability (0 <= p <= 1)
#   r = maximum range of capacity
#   s = random seed 
#   f = output file name
#
#  example: python3 gen.py 10 0.4 100 1234 data.in
#
#  It generates either:
#
#   1) a feasible graph, that is, there exists a path between vertice 1 and
#   vertice n, or
#
#   2) an infeasible graph, that is, there exists no path between vertice 1 and
#   vertice n. In this case, the output file contains only "-1"
#
#  Note that 2) may arise if the probability is too small
#
# ------------------------------------------------------------------------



import random
import sys

# ---------------------------
# graph traversal
# ---------------------------

def dfs(L, v, n, i):

    if i == n:
        return True
    if v[i] == False:
        v[i] = True
        for j in L[i]:
            if dfs(L, v, n, j) == True:
                
                return True
    return False

def dfs_iterative(L, visited, n, i):
        # Create a stack for DFS
        stack = []
 
        # Push the current source node.
        stack.append(i)
 
        while (len(stack)):
            # Pop a vertex from stack and print it
            i = stack[-1]
            stack.pop()

            if i == n:
                return True
 
            # Stack may contain same vertex twice. So
            # we need to print the popped item only
            # if it is not visited.
            if (not visited[i]):
                visited[i] = True
 
            # Get all adjacent vertices of the popped vertex s
            # If a adjacent has not been visited, then push it
            # to the stack.
            for node in L[i]:
                if (not visited[node]):
                    stack.append(node)

        if not any(visited):
            return True
        return False
 
# ----------------------------
# check that a path exists
# ----------------------------

def check(L, n):

    v = [False] * (n+1)
    return dfs_iterative(L, v, n, 1)


# ---------------------------
#  main function
# --------------------------

def main():

    sys.setrecursionlimit(10000)
    #start_time = time.time()
   
    argv = sys.argv[1:]
    n = int(argv[0])            # number of vertices
    p = float(argv[1])          # arc probability 
    r = int(argv[2])            # maximum range of capacity
    s = int(argv[3])            # random seed
    f = argv[4]

    random.seed(s)

    M = []
    L = [[] for i in range(n+1)]
    m = 0
    for i in range(1,n):
        for j in range(i+1,n+1):
            if random.random() < p:
                m = m + 1
                M.append([i,j])
                L[i].append(j)   

    fout = open(f,"w")

    if check(L,n) == True:
        fout.write(str(n) + " " + str(m) + "\n")
        count = 0
        content = ""
        for i in M:
            content += str(i[0]) + " " + str(i[1]) + " " + str(random.randint(1,r)) + "\n"
            if count % 200 == 0:
                fout.write(content)
                content = ""
            count += 1
        fout.write(content)
    else:
        fout.write("-1")
    
    fout.close()
    print("done")



if __name__ == "__main__":
    main()



    



