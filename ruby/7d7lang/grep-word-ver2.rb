# grep-word-ver2.rb
# code block +　`each_line` Method
key = "give"

def grep(line, keyword="Ruby")
    line.gsub(keyword,%Q(!!#{keyword}!!)) unless line !~ /#{keyword}/
end

File.open("ruby-license.txt", "r") do |file|
    i = 0
    file.each_line do |line| 
        i += 1
        print "Line ", i, ": ", grep(line, key) unless !grep(line, key)
    end
end
