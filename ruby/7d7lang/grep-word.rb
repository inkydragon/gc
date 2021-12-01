# grep-word.rb
# codeblock 
word = "give"

def grep(line, keyword="Ruby")
    line.gsub(keyword) {|match| %Q(!!#{match}!!)}
end


File.open("ruby-license.txt", "r") do |file|
    i = 0
    while line = file.gets
        i += 1
        if line != grep(line, word)
            print "Line ", i, ": ", grep(line, word) 
        end
    end
end
