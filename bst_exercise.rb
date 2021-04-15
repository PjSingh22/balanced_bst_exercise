class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(arr)
    return nil if arr.empty?

    mid = (arr.size - 1) / 2
    root_node = Node.new(arr[mid])

    root_node.left = build_tree(arr[0...mid])
    root_node.right = build_tree(arr[(mid + 1)..-1])

    root_node
  end

  def insert(val, root = @root)
    return Node.new(val) if root.nil?

    if root.data == val
      return root
    elsif root.data < val
      root.right = insert(val, root.right)
    else
      root.left = insert(val, root.left)
    end

    root
  end

  def min_value_node(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def delete(val, node = root)
    return val if node.nil?

    if val < node.data
      node.left = delete(val, node.left)
    elsif val > node.data
      node.right = delete(val, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      leftmost_node = min_value_node(node.right)
      node.data = leftmost_node.data
      node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  def find(val, node = root)
    return node if node.nil? || val == node.data

    if val > node.data
      find(val, node.right)
    else
      find(val, node.left)
    end
  end

  def level_order(queue = [@root])
    i = 0
    arr = []
    while queue[i]
      arr.push(queue[i].data)
      queue.push(queue[i].left)
      queue.push(queue[i].right)
      i += 1
    end
    arr
  end

  def inorder(node = root, arr = [])
    return if node.nil?

    inorder(node.left, arr)
    arr.push(node.data)
    inorder(node.right, arr)

    arr
  end

  def preorder(node = root, arr = [])
    return if node.nil?

    arr.push(node.data)
    preorder(node.left, arr)
    preorder(node.right, arr)

    arr
  end

  def postorder(node = root, arr = [])
    return if node.nil?

    postorder(node.left, arr)
    postorder(node.right, arr)
    arr.push(node.data)

    arr
  end

  def height(node = root)
    return 0 if node.nil?

    find_max(height(node.left), height(node.right)) + 1
  end

  def find_max(left_node, right_node)
    left_node >= right_node ? left_node : right_node
  end

  def depth(val, node = root)
    height(node) - height(find(val, node))
  end

  def balanced?(node = root)
    (height(node.left) - height(node.right)).abs <= 1
  end

  def rebalance(node = root)
    return nil if node.nil?
    arr = level_order
    if balanced?
      node
    else
      
    # end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
bst = Tree.new(arr)

# p bst.pretty_print
# bst.delete(3)
# bst.delete(7)
# bst.delete(5)
# bst.delete(4)
p bst.rebalance

# p bst.level_order

# puts bst.pretty_print