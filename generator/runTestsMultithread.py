import os, sys
from pickle import FALSE
import threading
import numpy as np
import multiprocessing, subprocess
from multiprocessing.dummy import Pool
import itertools
import random
import time
from hurry.filesize import size
from copy import deepcopy

TIMEOUT = 1800

one_file = True
p_values = [0.12, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.5, 0.6, 0.8, 1]
n_vertices = [2300] # [100, 150, 200, 250, 300, 350, 400, 450, 500, 600, 700, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2300, 2600, 2900, 3200, 3500, 4000, 4500, 5000, 5500]
cap = [10, 20, 30, 50, 80, 130, 210, 340, 500]

repeat = 5

limit_EK = None
limit_MPM = 0
limit_Dinic = 0


tests_done = 0
total_tests = repeat * len(n_vertices) * len(cap) * 3
total_time = 0
total_file_size = 0

error_timeout = False
error_file = False

arrMPM = [[[0 for _ in range(repeat)] for _ in range(len(cap))] for _ in range(len(n_vertices))]
arrEK = [[[0 for _ in range(repeat)] for _ in range(len(cap))] for _ in range(len(n_vertices))]
arrDinic = [[[0 for _ in range(repeat)] for _ in range(len(cap))] for _ in range(len(n_vertices))]


def generate_file(thread_id, p_value, n_vert, cap):
    global error_file, total_file_size

    if not os.path.exists('autoFiles'):
        os.makedirs('autoFiles')

    filePath = "autoFiles/testF" + str(thread_id) + ".txt"
    seed = random.randint(0, sys.maxsize)
    command = "python3 gen.py " + str(n_vert) + " " + str(p_value) + " " + str(cap) + " " + str(seed) + " " + filePath;
    p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    #out, error = p.communicate()
    #print(out, command)
    
    p.wait()

    #time.sleep(10)

    # check if file is valid
    if(len(open(filePath).readlines()) <= 1):
        error_file = True
        print(open(filePath).readlines())
        print("p_value: ", p_value, ", n_vert: ", n_vert, ", cap: ", cap, ", seed: ", seed, sep="")

    total_file_size += os.path.getsize(filePath)

    return filePath

def delete_file(filePath):
    if os.path.exists(filePath):
        os.remove(filePath) 


def runTest(arr):
    global arrMPM, arrEK, arrDinic, error_timeout, error_file, tests_done, total_time

    # error_timeout true, error detected, end program
    if error_timeout or error_file:
        return


    p_value, algo, n_ver_index, n_cap_index, run, counter = arr


    # generate test file
    filePath = generate_file(counter, p_value, n_vertices[n_ver_index], cap[n_cap_index])

    # error generating file
    if error_file:
        return

    #generate command to run test
    command_run = algo + " " + str(TIMEOUT) + " " + filePath

    out = os.popen(command_run).read()
    params = out.split("\n")
    if(float(params[0]) < 0):
        error_timeout = True
        print("Time out")
        return
    time = float(params[1])
    if(algo == "MPM"):
        arrMPM[n_ver_index][n_cap_index][run] = time
    elif(algo == "EK"):
        arrEK[n_ver_index][n_cap_index][run] = time
    elif(algo == "Dinic"):
        arrDinic[n_ver_index][n_cap_index][run] = time
    else:
        print("Time not added")
        return
    
    tests_done += 1
    total_time += time
    if(tests_done % int(total_tests * 0.2) == 0):
        print((tests_done * 100) / total_tests, "%  avg =>  ", round((total_time/tests_done), 2) , sep="")
    
    # delete file
    delete_file(filePath)

    return
   
def select_p_values():
    global p_values
    string = ""
    for index, p in enumerate(p_values):
        string += str(index) + " => " + str(p) + "\n"
    p_selected = ""
    while not p_selected:
        p_selected = str(input("Select p indexes: (split by ;)\n" + string))
    indexes = [int(x) for x in p_selected.split(";")]
    res = []
    for index in indexes:
        if(index == -1):
            return deepcopy(p_values[::-1])
        if(index < len(p_values)):
            res.append(p_values[index])
    return res


def main():
    global p_values, arrMPM, arrEK, arrDinic, tests_done, total_time, total_file_size, total_tests
    data = []
    while len(p_values) > 0:
        p_selected = select_p_values()

        for p_value in p_selected:
            print("Starting test p_value:", p_value)

            # reset vars
            arrMPM = [[[0 for _ in range(repeat)] for _ in range(len(cap))] for _ in range(len(n_vertices))]
            arrEK = [[[0 for _ in range(repeat)] for _ in range(len(cap))] for _ in range(len(n_vertices))]
            arrDinic = [[[0 for _ in range(repeat)] for _ in range(len(cap))] for _ in range(len(n_vertices))]
            tests_done = 0
            total_time = 0
            total_file_size = 0


        
            start_time = time.time()

            # generate params

            params = []
            counter = 0
            for t in range(3):
                for n_ver in range(len(n_vertices)):
                    for n_cap in range(len(cap)):
                        for r in range(repeat):
                            if t == 0:
                                algo = "MPM"
                                if limit_MPM != None and limit_MPM < n_vertices[n_ver]:
                                    continue
                            elif t == 1:
                                algo = "EK"
                                if limit_EK != None and limit_EK < n_vertices[n_ver]:
                                    continue
                            else:
                                algo = "Dinic"
                                if limit_Dinic != None and limit_Dinic < n_vertices[n_ver]:
                                    continue
                            params.append([p_value, algo, n_ver, n_cap, r, counter])
                            counter += 1
            
            total_tests = len(params)
            print("Number of tests:", len(params))
            np.random.shuffle(params)

            # create thread pool
            n_cpus = os.cpu_count()
            pool = Pool(n_cpus//2 - 1)
            async_result = pool.map_async(runTest, params)
            results = async_result.get()

            # check for errors
            if error_timeout:
                print("ERROR: error_timeout detected")
            
            if error_file:
                print("ERROR: error_file detected")
            
            if error_timeout or error_file:
                return


            # output files
            if not os.path.exists('results'):
                os.makedirs('results')

            if one_file:
                outFilePath = "results/resJoined.csv"
                file = open(outFilePath, "a+")
            else:
                outFilePath = "results/resP" + str(p_value) + ".csv"
                file = open(outFilePath, "w")
                file.write("File,Algorithm,P,n_vertices,max_cap,MeanTime\n")
            
            

            for index_v_vertices in range(len(n_vertices)):
                for index_cap in range(len(cap)):
                    #','.join(str(e) for e in arrMPM[i])
                    #str(np.mean(arrMPM[index_v_vertices][index_cap]))
                    fileName = "_p_" + str(p_value) + "_nVertices_" + str(n_vertices[index_v_vertices]) + "_maxValue_" + str(cap[index_cap]) + ".txt"
                    #file.write("MPM" + fileName + ",MPM," + str(p_value) + "," +  str(n_vertices[index_v_vertices]) + "," + str(cap[index_cap]) + "," + ','.join(str(e) for e in arrMPM[index_v_vertices][index_cap]) + "\n")
                    file.write("EK" + fileName + ",EK," + str(p_value) + "," +  str(n_vertices[index_v_vertices]) + "," + str(cap[index_cap]) + "," + ','.join(str(e) for e in arrEK[index_v_vertices][index_cap]) + "\n")
                    #file.write("Dinic" + fileName + ",Dinic," + str(p_value) + "," +  str(n_vertices[index_v_vertices]) + "," + str(cap[index_cap]) + "," + ','.join(str(e) for e in arrDinic[index_v_vertices][index_cap]) + "\n")


            file.close()

            #print stats of run
            total_file_size += os.path.getsize(outFilePath)

            hours, rem = divmod(time.time()-start_time, 3600)
            minutes, seconds = divmod(rem, 60)
            print("{:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))
            print("Data Written:", size(total_file_size))
            print(total_file_size)
            data.append([p_value, "{:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds), total_file_size])
            print(data)

            # update p_values
            p_values.remove(p_value)

    print(data)


if __name__ == "__main__":
    main()


