import os

def addContent(outPath, fileread, clearFile=False, skipFirstLine=True):
    fileIn = open(fileread, "r")
    content = fileIn.readlines()
    fileIn.close()

    if skipFirstLine:
        content = content[1:]

    if clearFile:
        fileOut = open(outPath, "w")
    else:
        fileOut = open(outPath, "a+")

    fileOut.writelines(content)
    fileOut.close()

def main():
    filelist = []
    dirname = os.path.dirname(__file__)
    folder = os.path.join(dirname, 'results')

    for file in os.listdir(folder):
        if file.find("resP") != -1:
            print(file)
            filelist.append('results/' + file)


    addContent("results/resAll.csv", filelist[0], clearFile=True, skipFirstLine=False)
    filelist = filelist[1:]
    for name in filelist:
        addContent("results/resAll.csv", name)

    print("done")

if __name__ == "__main__":
    main()