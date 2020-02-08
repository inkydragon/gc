# -*- coding:utf-8 -*-

import os,sys
import chardet

def get_ext(filename):  
    (filepath, tempfilename) = os.path.split(filename);  
    (shotname, extension) = os.path.splitext(tempfilename);  
    extension = extension[1:] # '.ext' => 'ext'
    return extension

def convert( filename, out_enc="UTF8" ):
    EXTENSION_LSIT = ['for', 'f90', 'txt', 'html']
    #ENCODING_LIST = ['GB2312', 'Windows-1252']

    print("trying to convert " + filename)
    try:
        with open(filename, mode='rb+') as f:
            content = f.read()
            file_encoding = chardet.detect(content)['encoding']
            ext = get_ext(filename)

            if (file_encoding != 'utf-8' and ext.lower() in EXTENSION_LSIT):
                print(file_encoding + " to utf-8!"),
                new_content = content.decode(file_encoding).encode(out_enc)
                f.seek(0)
                f.write(new_content)
                print(" done")
            else:
                print(file_encoding)
    except:
        print(" error")

def explore(dir):
    for root, dirs, files in os.walk(dir):
        for file in files:
            path = os.path.join(root, file)
            convert(path)

def main():
    for path in sys.argv[1:]:
        if os.path.isfile(path):
            convert(path)
        elif os.path.isdir(path):
            explore(path)

if __name__ == "__main__":
    main()
