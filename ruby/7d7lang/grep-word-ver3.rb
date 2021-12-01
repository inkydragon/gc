# grep-word-ver3.rb
# code block +　IO.foreach + Regexp + colorize

def grep(filename="testfile", re=/Ruby/)
    i = 0
    IO.foreach(filename) do |line|
        i += 1
        if line =~ re
            puts %Q(Line #{i}: #{$`}\033[42m#{$&}\033[0m#{$'})
        else
            nil
        end
    end            
end


grep("ruby-license.txt", /[ ]{1}with[ ]{1}/)