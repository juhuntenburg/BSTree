require_relative 'bstree/node'
require_relative 'bstree/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })

tree.balanced? ? puts("Tree is balanced") : puts("Tree is unbalanced")
print_str = "Preorder:"
tree.preorder { |node| print_str += " #{node.data}," }
puts print_str[..-2]
print_str = "Postorder:"
tree.postorder { |node| print_str += " #{node.data}," }
puts print_str[..-2]
print_str = "Inorder:"
tree.inorder { |node| print_str += " #{node.data}," }
puts print_str[..-2]
puts

tree.insert(101)
tree.insert(200)
tree.insert(166)

tree.balanced? ? puts("Tree is balanced") : puts("Tree is unbalanced")
tree.rebalance
tree.balanced? ? puts("Tree is balanced") : puts("Tree is unbalanced")
print_str = "Preorder:"
tree.preorder { |node| print_str += " #{node.data}," }
puts print_str[..-2]
print_str = "Postorder:"
tree.postorder { |node| print_str += " #{node.data}," }
puts print_str[..-2]
print_str = "Inorder:"
tree.inorder { |node| print_str += " #{node.data}," }
puts print_str[..-2]
