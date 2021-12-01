module ActsAsCsv
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    attr_accessor :headers, :csv_contents
    
    def initialize
      read
    end
    
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')
      
      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end
    
    def each(&block)
      @csv_contents.each {|contents| block.call(CsvRow.new(headers, contents))}
    end
    
    class CsvRow
      
      def initialize(headers, row)
        @headers = headers
        @row = row
      end
      
=begin
      # 暂不清楚作用， 注释掉不影响程序
      def respond_to?(name)
        @headers.index(name.to_s)
      end
=end
      
      def method_missing name, *args
        index = @headers.index(name.to_s)   
        @row[index] if index
      end
      
    end # class CvsRow END
    
  end # module InstanceMethods END
  
end # module ActsAsCsv END

class RubyCsv
  include ActsAsCsv
  acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect
m.each {|row| puts row.one, row.two}