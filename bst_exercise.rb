class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :array

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(array)
  end

  def build_tree(arr, first = 0, last = arr.length - 1)
    return nil if first > last

    mid = (first + last) / 2
    root = Node.new(arr[mid])
    root.left = build_tree(arr, first, mid - 1)
    root.right = build_tree(arr, mid + 1, last)

    root
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

  def level_order
    i = 0
    queue = [@root]
    arr = []
    while queue[i]
      arr.push(queue[i].data)
      queue.push(queue[i].left) if queue[i].left
      queue.push(queue[i].right) if queue[i].right
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
    return nil if node.nil?

    (height(node.left) - height(node.right)).abs <= 1
  end

  def rebalance
    @root = build_tree(level_order)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# 1. create a binary search tree from an array of random numbers.
bst = Tree.new(Array.new(15) { rand(1..100) })

# 2. confirm that the tree is balanced.
p bst.balanced?

# 3. Print out all elements in level, pre, post, and in order
p "level_order: #{bst.level_order}"
p "preorder: #{bst.preorder}"
p "postorder: #{bst.postorder}"
p "inorder: #{bst.inorder}"

# 4. try to unbalance the tree by adding several numbers > 100
bst.insert(1010)
bst.insert(245)
bst.insert(6693)
bst.insert(202)

# 5. Confirm that the tree is unbalanced.
p bst.balanced?

# Balance the tree.
bst.rebalance

# 7. Confirm that the tree is balanced.
p bst.balanced?

# 8. Print out all elements in level, pre, post, and in order.

p "level_order: #{bst.level_order}"
p "preorder: #{bst.preorder}"
p "postorder: #{bst.postorder}"
p "inorder: #{bst.inorder}"
p bst.pretty_print
