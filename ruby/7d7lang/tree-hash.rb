class Tree
    attr_accessor :children, :node_name

    def initialize(hash)
        hash.each do |name, children|
            @node_name = name
            @children = children.map {|key, value| Tree.new(key => value)}
        end    
    end
    
    def visit_all(&block)
        visit &block
        children.each {|c| c.visit_all &block}
    end
    
    def visit(&block)
        block.call self
    end    
end

ruby_tree = Tree.new({'grandpa' => {'dad' => {'child 1' => {}, 'child 2' => {}}, 'uncle' => {'child 3' => {}, 'child 4' => {} }}})

puts "visiting a node"
ruby_tree.visit {|node| puts node.node_name}
puts

puts "Visiting entire tree"
ruby_tree.visit_all {|node| puts node.node_name}