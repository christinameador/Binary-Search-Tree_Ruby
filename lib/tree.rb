# frozen_string_literal: true
#require 'pry'; binding.pry #rubocop:disable all

require_relative 'node'

# node within a binary search tree
class Tree
  def initialize(arr)
    arr = arr.uniq
    @root = build_tree(arr)
  end

  def build_tree(arr, first = 0, last = arr.length - 1)
    return nil if first > last

    arr = arr.sort.uniq
    mid = (first + last) / 2
    root = Node.new(arr[mid])
    root.left_child = build_tree(arr, first, mid - 1)
    root.right_child = build_tree(arr, mid + 1, last)
    root
  end

  def insert(value, root = @root)
    return Node.new(value) if root.nil?

    if root.data > value
      root.left_child = insert(value, root.left_child)
    elsif root.data < value
      root.right_child = insert(value, root.right_child)
    end
    root
  end

  def delete(value, root = @root)
    return root if root.nil?

    if root.data > value
      root.left_child = delete(value, root.left_child)
    elsif root.data < value
      root.right_child = delete(value, root.right_child)
    end

    if root.data == value
      if root.left_child.nil?
        root = root.right_child
      elsif root.right_child.nil?
        root = root.left_child
      else
        root.data = min_value(root.right_child)
        root.right_child = delete(root.data, root.right_child)
      end
    end

    root
  end

  def min_value(root)
    min_val = root.data
    while root.left_child
      min_val = root.left_child.data
      root = root.left_child
    end
    min_val
  end

  def find(value, root = @root)
    return root if root.nil? || root.data == value

    root = find(value, root.left_child) if value < root.data
    root = find(value, root.right_child) if value > root.data
    root
  end

  def level_order
    i = 0
    queue = [@root]
    arr = []
    while queue[i]
      arr.push(queue[i].data)
      queue.push(queue[i].left_child) if queue[i].left_child
      queue.push(queue[i].right_child) if queue[i].right_child
      i += 1
    end
    arr
  end

  def inorder(root = @root, arr = [])
    # visit left sub-tree
    inorder(root.left_child, arr) if root.left_child
    # visit root
    arr.push root.data
    # visit right sub-tree
    inorder(root.right_child, arr) if root.right_child
    arr
  end

  def preorder(root = @root, arr = [])
    # visit root
    arr.push root.data
    # visit left sub-tree
    preorder(root.left_child, arr) if root.left_child
    # visit right sub-tree
    preorder(root.right_child, arr) if root.right_child
    arr
  end

  def postorder(root = @root, arr = [])
    # visit left sub-tree
    postorder(root.left_child, arr) if root.left_child
    # visit right sub-tree
    postorder(root.right_child, arr) if root.right_child
    # visit root
    arr.push root.data
    arr
  end

  def height(root = @root)
    return 0 if root.nil?
    left = root.left_child ? height(root.left_child) : 0
    right = root.right_child ? height(root.right_child) : 0
    left > right ? left + 1 : right + 1
  end

  def depth(node)
    height(@root) - height(node)
  end

  def balanced?(root = @root)
    return true if root.nil?

    return true if balanced?(root.left_child) &&
                   balanced?(root.right_child) &&
                   (height(root.left_child) - height(root.right_child)).abs <= 1

    false
  end

  def rebalance
    @root = build_tree(level_order)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end 
end
