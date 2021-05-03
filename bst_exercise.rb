class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  def initialize(arr)
    @arr = arr.uniq.sort
    @root = build_tree(@arr, 0, @arr.length - 1)
  end

  def build_tree(arr, starting, ending)
    return if arr.empty? || starting > ending

    mid = (starting + ending) / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr, starting, mid - 1)
    root.right = build_tree(arr, mid + 1, ending)

    root
  end

  def insert(value, root = @root)
    return root = Node.new(value) if root.nil?

    if root.data == value
      puts "#{value} is already present in tree"
      root
    elsif value > root.data
      root.right = insert(value, root.right)
    else
      root.left = insert(value, root.left)
    end
    root
  end
#  test this function with prybug
def delete(value, root = @root)
  return value if root.nil?

  if value < root.data
    root.left = delete(value, root.left)
  elsif value > root.data
    root.right = delete(value, root.right)
  else
    return root.right if root.left.nil?
    return root.left if root.right.nil?

    temp = min_value_node(root.right)
    root.data = temp.data
    root.right = delete(temp.data, root.right)
  end
    root
  end

  def find(value, root = @root)
    return false if root.nil?
    return true if root.data == value

    if value < root.data
      root.left = find(value, root.left)
    else
      root.right = find(value, root.right)
    end
  end

  def level_order(node = @root)
    i = 0
    queue = [node]
    arr = []

    while queue[i]
      arr.push(queue[i].data)
      queue.push(queue[i].left) if queue[i].left
      queue.push(queue[i].right) if queue[i].right
      i += 1
    end
    arr
  end

  def inorder(node = @root, arr = [])
    return if node.nil?

    inorder(node.left, arr)
    arr.push(node.data)
    inorder(node.right, arr)

    arr
  end

  def preorder(node = @root, arr = [])
    return if node.nil?

    arr.push(node.data)
    preorder(node.left, arr)
    preorder(node.right, arr)

    arr
  end

  def postorder(node = @root, arr = [])
    return if node.nil?

    postorder(node.left, arr)
    postorder(node.right, arr)
    arr.push(node.data)

    arr
  end

  def height(node = @root)
    return 0 if node.nil?

    find_max(height(node.left), height(node.right)) + 1
  end

  def depth(node = @root)
    return 0 if node.nil?

    left_depth = depth(node.left)
    right_depth = depth(node.right)

    if left_depth > right_depth
      left_depth + 1
    else
      right_depth + 1
    end
  end

  def balanced?(node = @root)
    return nil if node.nil?

    (height(node.left) - height(node.right)).abs <= 1
  end

  def rebalance
    return @root if balanced?

    @arr = level_order
    @root = build_tree(level_order, 0, @arr.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def find_max(left_node, right_node)
    if left_node > right_node
      left_node
    else
      right_node
    end
  end

  def min_value_node(node)
    current = node
    current = current.left until current.left.nil?
    current
  end
end


bst = Tree.new(Array.new(15) { rand(1..100) })
p bst.balanced?
p bst.level_order
p bst.preorder
p bst.postorder
p bst.inorder
bst.insert(101)
bst.insert(200)
bst.insert(300)
p bst.balanced?
bst.rebalance
p bst.balanced?
bst.pretty_print
p bst.level_order
p bst.preorder
p bst.postorder
p bst.inorder
