

def changeLines(content_to_add, current_content):
    for content in content_to_add:
        file_name = content.split(',', 2)[0]
        for i in range(len(current_content)):
            if file_name == current_content[i].split(',', 2)[0]:
                current_content[i] = content
                break

    return current_content

def main():
    source_path = "results/resJoined.csv"
    result_path = "../data/resAllL.csv"

    file_source = open(source_path, "r")
    content_to_add = file_source.readlines()
    file_source.close()


    file_result = open(result_path, "r")
    current_content = file_result.readlines()
    file_result.close()

    updated_content = changeLines(content_to_add, current_content)

    fileOut = open(result_path, "w")
    fileOut.writelines(updated_content)
    fileOut.close()


if __name__ == '__main__':
    main()