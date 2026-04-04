// 数据结构 - 二叉树 - Binary Tree
import '../course_data.dart';

/// 二叉树章节
const chapterBinaryTree = CourseChapter(
  id: 'data_structures_binary_tree',
  title: '二叉树 (Binary Tree)',
  description: '学习 C++ 中二叉树的概念、遍历方式（先序、中序、后序、层序）以及二叉搜索树的实现。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'data_structures_binary_tree_concept',
      title: '二叉树概念与遍历',
      content: '''# 二叉树概念与遍历

## 什么是二叉树？

二叉树是每个节点最多有两个子节点的树形数据结构。

```
           1
         /   \\
        2     3
       / \\   / \\
      4   5 6   7
```

## 二叉树的术语

- **根节点 (Root)**：树的顶端节点
- **父节点/子节点 (Parent/Child)**：节点的上级/下级
- **叶子节点 (Leaf)**：没有子节点的节点
- **深度 (Depth)**：从根到该节点的路径长度
- **高度 (Height)**：从该节点到最深叶子节点的路径长度

## 二叉树的类型

1. **满二叉树 (Full)**: 每个节点都有 0 或 2 个子节点
2. **完全二叉树 (Complete)**: 除最后一层外，每层都填满，且最后一层从左到右填充
3. **完美二叉树 (Perfect)**: 所有叶子节点在同一层
4. **二叉搜索树 (BST)**: 左子树所有节点 < 根 < 右子树所有节点

## 二叉树的存储

### 顺序存储（适合完全二叉树）

```cpp
// 节点 i 的孩子: 2i+1, 2i+2
// 节点 i 的父节点: (i-1)/2
```

### 链式存储

```cpp
struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};
```

## 二叉树的遍历

| 遍历方式 | 顺序 | 应用 |
|----------|------|------|
| 先序 (Preorder) | 根-左-右 | 复制树、前缀表达式 |
| 中序 (Inorder) | 左-根-右 | BST 升序遍历 |
| 后序 (Postorder) | 左-右-根 | 删除树、后缀表达式 |
| 层序 (Level order) | 按层 | BFS、最短路径 |

## 递归遍历模板

```cpp
void preorder(TreeNode* root) {
    if (!root) return;
    // 访问根
    visit(root);
    // 访问左子树
    preorder(root->left);
    // 访问右子树
    preorder(root->right);
}
```
''',
      codeExamples: [
        CodeExample(
          title: '二叉树遍历实现',
          code: '''#include <iostream>
#include <queue>
#include <vector>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

class BinaryTree {
private:
    TreeNode* root;

public:
    BinaryTree() : root(nullptr) {}

    void setRoot(TreeNode* node) { root = node; }

    // 先序遍历: 根-左-右
    void preorder(TreeNode* node) {
        if (!node) return;
        cout << node->val << " ";
        preorder(node->left);
        preorder(node->right);
    }

    // 中序遍历: 左-根-右
    void inorder(TreeNode* node) {
        if (!node) return;
        inorder(node->left);
        cout << node->val << " ";
        inorder(node->right);
    }

    // 后序遍历: 左-右-根
    void postorder(TreeNode* node) {
        if (!node) return;
        postorder(node->left);
        postorder(node->right);
        cout << node->val << " ";
    }

    // 层序遍历 (BFS)
    void levelorder(TreeNode* node) {
        if (!node) return;
        queue<TreeNode*> q;
        q.push(node);

        while (!q.empty()) {
            TreeNode* current = q.front();
            q.pop();
            cout << current->val << " ";

            if (current->left) q.push(current->left);
            if (current->right) q.push(current->right);
        }
    }

    // 层序遍历（分层输出）
    void levelorder分层(TreeNode* node) {
        if (!node) return;
        queue<TreeNode*> q;
        q.push(node);

        while (!q.empty()) {
            int levelSize = q.size();
            for (int i = 0; i < levelSize; i++) {
                TreeNode* current = q.front();
                q.pop();
                cout << current->val << " ";

                if (current->left) q.push(current->left);
                if (current->right) q.push(current->right);
            }
            cout << endl;
        }
    }

    TreeNode* getRoot() { return root; }
};

// 构建示例树
/*
           1
         /   \\
        2     3
       / \\   / \\
      4   5 6   7
*/
TreeNode* buildSampleTree() {
    TreeNode* n1 = new TreeNode(1);
    TreeNode* n2 = new TreeNode(2);
    TreeNode* n3 = new TreeNode(3);
    TreeNode* n4 = new TreeNode(4);
    TreeNode* n5 = new TreeNode(5);
    TreeNode* n6 = new TreeNode(6);
    TreeNode* n7 = new TreeNode(7);

    n1->left = n2;
    n1->right = n3;
    n2->left = n4;
    n2->right = n5;
    n3->left = n6;
    n3->right = n7;

    return n1;
}

int main() {
    cout << "=== 二叉树遍历 ===" << endl;
    BinaryTree tree;
    tree.setRoot(buildSampleTree());

    cout << "先序 (根-左-右): ";
    tree.preorder(tree.getRoot());
    cout << endl;

    cout << "中序 (左-根-右): ";
    tree.inorder(tree.getRoot());
    cout << endl;

    cout << "后序 (左-右-根): ";
    tree.postorder(tree.getRoot());
    cout << endl;

    cout << "层序 (按层): ";
    tree.levelorder(tree.getRoot());
    cout << endl;

    cout << "\\n层序分层输出:" << endl;
    tree.levelorder分层(tree.getRoot());

    return 0;
}''',
          description: '展示二叉树的递归遍历（先序、中序、后序）和层序遍历（BFS）的实现。',
          output: '''=== 二叉树遍历 ===
先序 (根-左-右): 1 2 4 5 3 6 7 
中序 (左-根-右): 4 2 5 1 6 3 7 
后序 (左-右-根): 4 5 2 6 7 3 1 
层序 (按层): 1 2 3 4 5 6 7 

层序分层输出:
1 
2 3 
4 5 6 7''',
        ),
        CodeExample(
          title: '非递归遍历实现',
          code: '''#include <iostream>
#include <stack>
#include <queue>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

// 非递归先序遍历 (根-左-右)
void preorderIterative(TreeNode* root) {
    if (!root) return;
    stack<TreeNode*> s;
    s.push(root);

    while (!s.empty()) {
        TreeNode* node = s.top();
        s.pop();
        cout << node->val << " ";

        // 先压右子树，再压左子树，这样左子树先出栈
        if (node->right) s.push(node->right);
        if (node->left) s.push(node->left);
    }
}

// 非递归中序遍历 (左-根-右)
void inorderIterative(TreeNode* root) {
    stack<TreeNode*> s;
    TreeNode* current = root;

    while (current || !s.empty()) {
        // 一直向左走到最深处
        while (current) {
            s.push(current);
            current = current->left;
        }

        // 处理栈顶节点
        current = s.top();
        s.pop();
        cout << current->val << " ";

        // 转向右子树
        current = current->right;
    }
}

// 非递归后序遍历 (左-右-根)
void postorderIterative(TreeNode* root) {
    if (!root) return;
    stack<TreeNode*> s1, s2;
    s1.push(root);

    while (!s1.empty()) {
        TreeNode* node = s1.top();
        s1.pop();
        s2.push(node);  // 根先入 s2

        if (node->left) s1.push(node->left);
        if (node->right) s1.push(node->right);
    }

    // s2 出栈顺序就是后序
    while (!s2.empty()) {
        cout << s2.top()->val << " ";
        s2.pop();
    }
}

// 层序遍历（BFS）
void levelorderIterative(TreeNode* root) {
    if (!root) return;
    queue<TreeNode*> q;
    q.push(root);

    while (!q.empty()) {
        TreeNode* node = q.front();
        q.pop();
        cout << node->val << " ";

        if (node->left) q.push(node->left);
        if (node->right) q.push(node->right);
    }
}

// 构建示例树
TreeNode* buildSampleTree() {
    TreeNode* n1 = new TreeNode(1);
    TreeNode* n2 = new TreeNode(2);
    TreeNode* n3 = new TreeNode(3);
    TreeNode* n4 = new TreeNode(4);
    TreeNode* n5 = new TreeNode(5);
    TreeNode* n6 = new TreeNode(6);
    TreeNode* n7 = new TreeNode(7);

    n1->left = n2;
    n1->right = n3;
    n2->left = n4;
    n2->right = n5;
    n3->left = n6;
    n3->right = n7;

    return n1;
}

int main() {
    cout << "=== 非递归遍历 ===" << endl;
    TreeNode* root = buildSampleTree();

    cout << "先序 (栈): ";
    preorderIterative(root);
    cout << endl;

    cout << "中序 (栈): ";
    inorderIterative(root);
    cout << endl;

    cout << "后序 (双栈): ";
    postorderIterative(root);
    cout << endl;

    cout << "层序 (队列): ";
    levelorderIterative(root);
    cout << endl;

    cout << "\\n=== 遍历对比 ===" << endl;
    cout << "递归实现简单直观，非递归实现效率更高（避免栈溢出）" << endl;
    cout << "中序遍历 BST 会得到升序序列" << endl;

    return 0;
}''',
          description: '展示二叉树非递归遍历的三种实现：先序（单栈）、中序（单栈）、后序（双栈）。',
          output: '''=== 非递归遍历 ===
先序 (栈): 1 2 4 5 3 6 7 
中序 (栈): 4 2 5 1 6 3 7 
后序 (双栈): 4 5 2 6 7 3 1 
层序 (队列): 1 2 3 4 5 6 7 

=== 遍历对比 ===
递归实现简单直观，非递归实现效率更高（避免栈溢出）
中序遍历 BST 会得到升序序列''',
        ),
      ],
      keyPoints: [
        '二叉树遍历：先序(根左右)、中序(左根右)、后序(左右根)、层序(按层)',
        '递归遍历简洁但深度过大会栈溢出，非递归遍历用显式栈更安全',
        '中序遍历二叉搜索树会得到升序序列',
        '层序遍历用队列实现，体现 BFS 思想',
        '后序遍历双栈法：第一个栈保存顺序为根-右-左，第二个栈弹出即为左-右-根',
      ],
    ),

    CourseLesson(
      id: 'data_structures_binary_tree_bst',
      title: '二叉搜索树 (BST)',
      content: '''# 二叉搜索树 (BST)

## BST 的定义

二叉搜索树是一种特殊的二叉树，满足以下性质：

```
左子树所有节点 < 根节点 < 右子树所有节点
```

```
           8
         /   \\
        3     10
       / \\    \\
      1   6    14
         / \\   /
        4   7  13
```

## BST 的基本操作

| 操作 | 时间复杂度 | 说明 |
|------|------------|------|
| 查找 | O(h) | h 为树的高度 |
| 插入 | O(h) | 插入新节点 |
| 删除 | O(h) | 删除节点 |
| 遍历 | O(n) | 中序遍历得到升序 |

## BST 查找

```cpp
TreeNode* search(TreeNode* root, int key) {
    if (!root || root->val == key) return root;
    if (key < root->val)
        return search(root->left, key);
    else
        return search(root->right, key);
}
```

## BST 插入

插入新节点时，从根开始比较，小于往左走，大于往右走：

```cpp
TreeNode* insert(TreeNode* root, int val) {
    if (!root) return new TreeNode(val);
    if (val < root->val)
        root->left = insert(root->left, val);
    else if (val > root->val)
        root->right = insert(root->right, val);
    return root;
}
```

## BST 删除

删除有三种情况：

1. **叶子节点**：直接删除
2. **只有一个子节点**：用子节点替换
3. **有两个子节点**：用后继节点（最小值）或前驱节点（最大值）替换

## BST 的特点

- **有序性**：中序遍历得到升序序列
- **查找效率高**：平均 O(log n)，最坏 O(n)（树退化成链表）
- **自动排序**：插入时自动维护顺序
- **应用**：符号表、字典、数据库索引

## 平衡二叉树

为了避免 BST 退化成链表，出现了多种平衡树：

- **AVL 树**：严格平衡，左右子树高度差 ≤ 1
- **红黑树**：近似平衡，插入/删除操作更高效
- **B 树/B+ 树**：用于数据库和文件系统
''',
      codeExamples: [
        CodeExample(
          title: 'BST 的实现',
          code: '''#include <iostream>
#include <queue>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

class BST {
private:
    TreeNode* root;

public:
    BST() : root(nullptr) {}

    // 查找
    TreeNode* search(int key) {
        TreeNode* current = root;
        while (current) {
            if (key == current->val) return current;
            else if (key < current->val) current = current->left;
            else current = current->right;
        }
        return nullptr;
    }

    // 插入
    void insert(int val) {
        if (!root) {
            root = new TreeNode(val);
            return;
        }

        TreeNode* current = root;
        while (true) {
            if (val < current->val) {
                if (!current->left) {
                    current->left = new TreeNode(val);
                    return;
                }
                current = current->left;
            } else if (val > current->val) {
                if (!current->right) {
                    current->right = new TreeNode(val);
                    return;
                }
                current = current->right;
            } else {
                return;  // 不插入重复值
            }
        }
    }

    // 找最小值节点
    TreeNode* findMin(TreeNode* node) {
        while (node && node->left) node = node->left;
        return node;
    }

    // 删除
    TreeNode* remove(int val) {
        root = deleteNode(root, val);
        return root;
    }

    TreeNode* deleteNode(TreeNode* node, int val) {
        if (!node) return nullptr;

        if (val < node->val) {
            node->left = deleteNode(node->left, val);
        } else if (val > node->val) {
            node->right = deleteNode(node->right, val);
        } else {
            // 找到要删除的节点

            // 情况1: 叶子节点
            if (!node->left && !node->right) {
                delete node;
                return nullptr;
            }

            // 情况2: 只有一个子节点
            if (!node->left) {
                TreeNode* temp = node->right;
                delete node;
                return temp;
            }
            if (!node->right) {
                TreeNode* temp = node->left;
                delete node;
                return temp;
            }

            // 情况3: 有两个子节点 - 用后继替换
            TreeNode* successor = findMin(node->right);
            node->val = successor->val;
            node->right = deleteNode(node->right, successor->val);
        }
        return node;
    }

    // 中序遍历 (升序)
    void inorder(TreeNode* node) {
        if (!node) return;
        inorder(node->left);
        cout << node->val << " ";
        inorder(node->right);
    }

    void printInorder() {
        cout << "中序遍历 (升序): ";
        inorder(root);
        cout << endl;
    }

    TreeNode* getRoot() { return root; }
};

int main() {
    cout << "=== BST 基本操作 ===" << endl;
    BST bst;

    // 插入
    vector<int> values = {8, 3, 10, 1, 6, 14, 4, 7, 13};
    for (int v : values) {
        bst.insert(v);
    }

    bst.printInorder();

    // 查找
    cout << "\\n=== 查找 ===" << endl;
    int keys[] = {6, 15};
    for (int key : keys) {
        TreeNode* result = bst.search(key);
        cout << "查找 " << key << ": "
             << (result ? "找到" : "未找到") << endl;
    }

    // 删除
    cout << "\\n=== 删除 ===" << endl;
    cout << "删除 6 (有两个子节点) 前: ";
    bst.printInorder();

    bst.remove(6);
    cout << "删除 6 后: ";
    bst.printInorder();

    cout << "删除 8 (根节点) 后: ";
    bst.remove(8);
    bst.printInorder();

    return 0;
}''',
          description: '展示 BST 的插入、查找、删除操作的完整实现，包括三种删除情况。',
          output: '''=== BST 基本操作 ===
中序遍历 (升序): 1 3 4 6 7 8 10 13 14 

=== 查找 ===
查找 6: 找到
查找 15: 未找到

=== 删除 ===
删除 6 (有两个子节点) 前: 1 3 4 6 7 8 10 13 14 
删除 6 后: 1 3 4 7 8 10 13 14 
删除 8 (根节点) 后: 1 3 4 7 10 13 14''',
        ),
        CodeExample(
          title: 'BST 经典应用',
          code: '''#include <iostream>
#include <vector>
using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

// 验证 BST
bool isValidBST(TreeNode* root) {
    return validate(root, nullptr, nullptr);
}

bool validate(TreeNode* node, TreeNode* minNode, TreeNode* maxNode) {
    if (!node) return true;
    if (minNode && node->val <= minNode->val) return false;
    if (maxNode && node->val >= maxNode->val) return false;
    return validate(node->left, minNode, node) &&
           validate(node->right, node, maxNode);
}

// 找 BST 第 K 小的元素
int kthSmallest(TreeNode* root, int& k) {
    if (!root) return -1;

    // 中序遍历，第 k 个就是答案
    int val = kthSmallest(root->left, k);
    if (k == 0) return val;

    k--;
    if (k == 0) return root->val;

    return kthSmallest(root->right, k);
}

// 查找两个节点的最近公共祖先 (LCA)
TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
    if (!root) return nullptr;

    // 如果 p 和 q 都在右子树
    if (p->val > root->val && q->val > root->val) {
        return lowestCommonAncestor(root->right, p, q);
    }

    // 如果 p 和 q 都在左子树
    if (p->val < root->val && q->val < root->val) {
        return lowestCommonAncestor(root->left, p, q);
    }

    // 否则 root 就是 LCA
    return root;
}

// 将有序数组转换为 BST
TreeNode* sortedArrayToBST(vector<int>& nums, int left, int right) {
    if (left > right) return nullptr;

    int mid = left + (right - left) / 2;
    TreeNode* node = new TreeNode(nums[mid]);
    node->left = sortedArrayToBST(nums, left, mid - 1);
    node->right = sortedArrayToBST(nums, mid + 1, right);
    return node;
}

void inorder(TreeNode* node) {
    if (!node) return;
    inorder(node->left);
    cout << node->val << " ";
    inorder(node->right);
}

int main() {
    cout << "=== 验证 BST ===" << endl;
    TreeNode* valid = new TreeNode(2);
    valid->left = new TreeNode(1);
    valid->right = new TreeNode(3);
    cout << "valid BST: " << (isValidBST(valid) ? "是" : "否") << endl;

    TreeNode* invalid = new TreeNode(5);
    invalid->left = new TreeNode(1);
    invalid->right = new TreeNode(4);
    invalid->right->left = new TreeNode(3);
    invalid->right->right = new TreeNode(6);
    cout << "invalid BST: " << (isValidBST(invalid) ? "是" : "否") << endl;

    cout << "\\n=== BST 第 K 小的元素 ===" << endl;
    TreeNode* root = new TreeNode(5);
    root->left = new TreeNode(3);
    root->right = new TreeNode(6);
    root->left->left = new TreeNode(2);
    root->left->right = new TreeNode(4);
    root->left->left->left = new TreeNode(1);

    int k = 3;
    cout << "第 " << k << " 小的元素: " << kthSmallest(root, k) << endl;

    cout << "\\n=== 最近公共祖先 ===" << endl;
    TreeNode* p = root->left->left;  // 节点 1
    TreeNode* q = root->left->right;  // 节点 4
    TreeNode* lca = lowestCommonAncestor(root, p, q);
    cout << "LCA(" << p->val << ", " << q->val << ") = " << lca->val << endl;

    cout << "\\n=== 有序数组转 BST ===" << endl;
    vector<int> nums = {1, 2, 3, 4, 5, 6, 7};
    TreeNode* bst = sortedArrayToBST(nums, 0, nums.size() - 1);
    cout << "转换后中序遍历: ";
    inorder(bst);
    cout << endl;

    return 0;
}''',
          description: '展示 BST 的几个经典应用：验证 BST、找第 K 小元素、求最近公共祖先、有序数组转 BST。',
          output: '''=== 验证 BST ===
valid BST: 是
invalid BST: 否

=== BST 第 K 小的元素 ===
第 3 小的元素: 3

=== 最近公共祖先 ===
LCA(1, 4) = 3

=== 有序数组转 BST ===
转换后中序遍历: 1 2 3 4 5 6 7''',
        ),
      ],
      keyPoints: [
        'BST 性质：左子树所有节点 < 根 < 右子树所有节点',
        'BST 中序遍历得到升序序列',
        '删除有两个子节点的节点时，用后继（右下最小）或前驱（左下最大）替换',
        '验证 BST 时，每个节点需要在 (min, max) 范围内递归验证',
        '有序数组转 BST：选择中间元素作为根，左半部分递归构建左子树',
      ],
    ),
  ],
);
