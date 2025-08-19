# frozen_string_literal: true

require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr)
    super()
  end

  def build_tree(arr)
    arr = arr.uniq.sort
    build_tree_recursion(arr, 0, arr.size - 1)
  end

  def build_tree_recursion(arr, start_idx, end_idx)
    return nil if start_idx > end_idx

    mid_idx = start_idx + (end_idx - start_idx) / 2
    root = Node.new(arr[mid_idx])
    root.left = build_tree_recursion(arr, start_idx, mid_idx - 1)
    root.right = build_tree_recursion(arr, mid_idx + 1, end_idx)
    root
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true) if node.left
  end

  def next_biggest(node)
    # the next biggest node is always the leftmost value in the right subtree
    node = node.right # right subtree
    node = node.left while node&.left # leftmost value
    node
  end

  def insert(value, root = @root)
    return Node.new(value) unless root

    return root if value == root.data

    if value < root.data
      root.left = insert(value, root.left)
    elsif value > root.data
      root.right = insert(value, root.right)
    end
    root
  end

  def delete(value, root = @root)
    # if we get to nil without returning the value wasn't in the tree
    return @root if root.nil?

    # move down the tree to find the value and replace it by the return value
    # of the next recursion once that hits the value
    root.left = delete(value, root.left) if value < root.data
    root.right = delete(value, root.right) if value > root.data

    # once we hit the value
    if value == root.data
      # if it has only one subtree, replace the current node with its subtree
      return root.left || root.right if root.left.nil? || root.right.nil?

      # otherwise we have to find the next biggest value in its subtree
      # swap the value and delete the original next biggest
      next_biggest = next_biggest(root)
      root.data = next_biggest.data
      root.right = delete(next_biggest.data, root.right)
    end
    root
  end

  def find(value)
    current = root
    until current.nil? || current.data == value
      current = value < current.data ? current.left : current.right
    end
    current
  end

  def level_order
    queue = [@root]
    collect = [] unless block_given?
    until queue.empty?
      current = queue.shift
      queue << current.left if current.left
      queue << current.right if current.right
      block_given? ? yield(current) : collect.push(current)
    end
    collect unless block_given?
  end

  def level_order_recursive(queue = [@root], collect = [], &block)
    return collect if queue.empty?

    current = queue.shift
    block ? block.call(current) : collect.push(current)
    queue << current.left if current.left
    queue << current.right if current.right
    level_order_recursive(queue, collect, &block)
  end

  def preorder(current = @root, collect = [], &block)
    return collect if current.nil?

    block ? block.call(current) : collect.push(current.data)
    preorder(current.left, collect, &block)
    preorder(current.right, collect, &block)
  end

  def inorder(current = @root, collect = [], &block)
    return collect if current.nil?

    inorder(current.left, collect, &block)
    block ? block.call(current) : collect.push(current.data)
    inorder(current.right, collect, &block)
  end

  def postorder(current = @root, collect = [], &block)
    return collect if current.nil?

    postorder(current.left, collect, &block)
    postorder(current.right, collect, &block)
    block ? block.call(current) : collect.push(current.data)
  end

  def height(value)
    node = find(value)
    node ? height_rec(node) - 1 : nil
  end

  def height_rec(root, height = 1)
    left_height = root.left ? height_rec(root.left, height) : 0
    right_height = root.right ? height_rec(root.right, height) : 0
    height += [left_height, right_height].max
    height
  end

  def depth(value)
    current = root
    depth = 0
    until current.data == value
      current = value < current.data ? current.left : current.right
      depth += 1
      return nil unless current
    end
    depth
  end

  def balanced?(root = @root)
    return true if root.nil?

    left_height = root.left ? height(root.left.data) : 0
    right_height = root.right ? height(root.right.data) : 0
    if (left_height - right_height).abs > 1
      return false
    elsif root.left.nil? && root.right.nil?
      return true
    else
      return balanced?(root.left) && balanced?(root.right)
    end
  end

  def rebalance
    arr = inorder
    @root = build_tree(arr)
  end
end
