module JStruct
    export B,L,Struct,TypeContainer,Int8b,Int8l,Int16b,Int16l,Int32b,Int32l,Int64b,Int64l,
    Int8ub,Int8ul,Int16ub,Int16ul,Int32ub,Int32ul,Int64ub,Int64ul,CharField,
    Parse,Build

    bigEndian='B'
    littleEndian='L'
    B=BigEndian(T)=(T,bigEndian)
    L=LittleEndian(T) = (T,littleEndian)
    #little endian
    Int8ul=L(UInt8)
    Int16ul=L(UInt16)
    Int32ul=L(UInt32)
    Int64ul=L(UInt64)
    Int8l=L(Int8)
    Int16l=L(Int16)
    Int32l=L(Int32)
    Int64l=L(Int64)
    #big endian
    Int8ub=B(UInt8)
    Int16ub=B(UInt16)
    Int32ub=B(UInt32)
    Int64ub=B(UInt64)
    Int8b=B(Int8)
    Int16b=B(Int16)
    Int32b=B(Int32)
    Int64b=B(Int64)

	
    struct TypeContainer
        keylist::Array
        dic::Dict
    end
	
	struct CharField
		len::Integer
        chars::Array{Char,1}

        function CharField(len::Integer)
			new(len,[])
		end
            
	end
	
	
    struct Struct
        typelist::Array
        keylist::Array

        function Struct(data::TypeContainer)
            typelist=[]
            keylist=[]
            for key in data.keylist
               push!(keylist,key)
               push!(typelist,data.dic[key])
            end
			new(typelist,keylist)
        end
    end
	
	function Build(st::Struct,data::Dict)

	end
	
	function Parse(st::Struct,data::IOBuffer)
	    result=Dict()
		i=1
        while i<=length(st.keylist)
			#处理自定义类型，如字符串
			if !(typeof(st.typelist[i])<:Tuple)
				if typeof(st.typelist[i])==CharField
					j=1
					while j<=st.typelist[i].len
						push!(st.typelist[i].chars,read(data,Char))
						j=j+1
					end
#                     println(st.typelist[i].chars)
					push!(result,st.keylist[i]=>String(st.typelist[i].chars))
				end
                i=i+1
				continue
			end
			tpe=st.typelist[i][1]
			endian=st.typelist[i][2]
			frame=read(data,tpe)
            #如果本机是小端字节序，并且发送的字节是小端序，read时会变成大端字节序，需要再进行一次转换
            #而如果本机是小端字节序，并且发送字节是大端序，则不需要进行任何装换
			if ENDIAN_BOM==0x04030201 && endian==littleEndian
				frame=ntoh(frame)
            #如果本机是大端字节序，并且发送字节是大端序，则不需要进行任何操作
            #如果本机是大端字节序，并且发送字节是小端序，则需要进行一次转换
			elseif ENDIAN_BOM==0x01020304 && endian==bigEndian
				frame=ltoh(frame)
			end
			push!(result,st.keylist[i]=>tpe(frame))
            i=i+1
        end
		result
	end

end