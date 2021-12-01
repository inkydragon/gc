require "spec"
def assert_equals(expected, actual, message=nil)
  if (expected == actual)
    expected.should eq actual
  elsif !message
    expected.should eq actual
  else
    raise Exception.new(message.to_s)
  end
end

def tst(a, b)
  "#{a} is #{["equal to", "greater than", "smaller than"][a <=> b]} #{b}"
end

def no_ifs_no_buts(a, b)
  case 
  when a > b
    "#{a} is greater than #{b}"
  when a == b
    "#{a} is equal to #{b}"
  when a<b
    "#{a} is smaller than #{b}"
  end
end

a=1
b=1
assert_equals(no_ifs_no_buts(a, b), "#{a} is equal to #{b}")
