module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def acts_as_csv
      include InstanceMethods
      include Enumerable
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
      
      @headers = parse_row file.gets
            
      file.each do |row|
        @csv_contents << CsvRow.new(@headers, parse_row(row))
      end
    end
    
    def parse_row(row)
      row.chomp.split(', ')
    end
    
    def each
      @csv_contents.each { |row| yield row }
    end
        
    class CsvRow
      def initialize(headers, row)
        @headers = headers
        @row = row
      end
      
      def respond_to?(name)
        @headers.index(name.to_s) || super(sym)
      end
      
      def method_missing name, *args, &block
        index = @headers.index(name.to_s)
        if index
          @row[index]
        else
          super
        end        
      end      
    end
  end
end

class RubyCsv
  include ActsAsCsv
  acts_as_csv
end

csv = RubyCsv.new
puts csv.headers.inspect
puts csv.csv_contents.inspect
csv.each { |row| puts "#{row.name}, #{row.age}" }