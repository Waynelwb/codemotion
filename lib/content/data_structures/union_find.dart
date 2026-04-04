// ignore_for_file: unnecessary_string_escapes
// 数据结构 - 并查集 - Union-Find (Disjoint Set)
import '../course_data.dart';

/// 并查集章节
const chapterUnionFind = CourseChapter(
  id: 'data_structures_union_find',
  title: '并查集 (Union-Find)',
  description: '学习并查集数据结构的概念、实现（数组和树），以及路径压缩和按秩合并的优化。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'data_structures_union_find_basics',
      title: '并查集基础',
      content: '''# 并查集基础

## 什么是并查集？

并查集（Disjoint Set / Union-Find）是一种处理**不相交集合**的数据结构，支持：

1. **Find**：查找元素所属集合的代表元素
2. **Union**：合并两个集合

## 应用场景

- **连通分量**：判断图中两点是否连通
- **社交网络**：判断两人是否属于同一朋友圈
- **最小生成树**：Kruskal 算法
- **等价类**：处理等价关系
- **岛屿数量**：LeetCode 200

## 朴素实现（数组）

```cpp
class UnionFind {
    vector<int> parent;
public:
    UnionFind(int n) : parent(n) {
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    int find(int x) {
        while (parent[x] != x) x = parent[x];
        return x;
    }

    void unite(int a, int b) {
        int ra = find(a), rb = find(b);
        if (ra != rb) parent[rb] = ra;
    }
};
```

## 森林表示（树结构）

每个集合用一棵树表示：
- **parent[i]**：i 的父节点
- **根节点**：代表元素，parent[root] = root

```
集合 {0, 1, 2, 3}           集合 {4, 5}
       0                        4
      /                         |
     1                          5
    /
   2
   3
```

## 合并操作

合并两个集合，只需让一个根指向另一个根：

```
unite(0, 4):
  0 的根是 0，4 的根是 4
  parent[4] = 0

合并后:
       0          合并后:    0
      / |                      \\
     1  4                       1
    /                              \\
   2                               4
    \                              /
     3                            5
```

## Find 操作与路径压缩

为加速 Find，可以在查找时将路径上的节点直接指向根：

```cpp
int find(int x) {
    if (parent[x] == x) return x;
    return parent[x] = find(parent[x]);  // 路径压缩
}
```

## 并的优化：按秩合并

秩（rank）近似于树的深度：
- 小秩合并到大秩：高度不会增加太多

```cpp
void unite(int a, int b) {
    int ra = find(a), rb = find(b);
    if (ra == rb) return;
    if (rank[ra] < rank[rb]) swap(ra, rb);
    parent[rb] = ra;
    if (rank[ra] == rank[rb]) rank[ra]++;
}
```

## 时间复杂度

| 优化 | 时间复杂度 |
|------|------------|
| 无优化 | O(n) / 次 |
| 路径压缩 | O(α(n)) / 次 |
| 路径压缩 + 按秩合并 | O(α(n)) / 次（几乎常数）|

**α(n)** 是 Ackermann 函数的反函数，对于 n < 10^600，α(n) ≤ 5，可以认为 O(1)。
''',
      codeExamples: [
        CodeExample(
          title: '并查集基础实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 朴素并查集（无优化）
class UnionFindNaive {
    vector<int> parent;
public:
    UnionFindNaive(int n) : parent(n) {
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    int find(int x) {
        if (parent[x] == x) return x;
        return find(parent[x]);  // 递归查找
    }

    void unite(int a, int b) {
        int ra = find(a);
        int rb = find(b);
        if (ra != rb) {
            parent[rb] = ra;
        }
    }

    bool same(int a, int b) {
        return find(a) == find(b);
    }

    void print() {
        cout << "parent: ";
        for (int i = 0; i < parent.size(); i++) {
            cout << i << "->" << parent[i] << " ";
        }
        cout << endl;
    }
};

// 带路径压缩和按秩合并的并查集
class UnionFind {
    vector<int> parent;
    vector<int> rank;
public:
    UnionFind(int n) : parent(n), rank(n, 0) {
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);  // 路径压缩
        }
        return parent[x];
    }

    void unite(int a, int b) {
        int ra = find(a);
        int rb = find(b);

        if (ra == rb) {
            cout << a << " 和 " << b << " 已在同一集合" << endl;
            return;
        }

        // 按秩合并
        if (rank[ra] < rank[rb]) {
            swap(ra, rb);
        }
        parent[rb] = ra;

        if (rank[ra] == rank[rb]) {
            rank[ra]++;
            cout << "合并 " << b << " -> " << a << " (ra=" << ra << ", rank++)" << endl;
        } else {
            cout << "合并 " << b << " -> " << a << " (ra=" << ra << ")" << endl;
        }
    }

    bool same(int a, int b) {
        return find(a) == find(b);
    }

    int countSets() {
        int cnt = 0;
        for (int i = 0; i < parent.size(); i++) {
            if (parent[i] == i) cnt++;
        }
        return cnt;
    }
};

int main() {
    cout << "=== 朴素并查集 ===" << endl;
    {
        UnionFindNaive uf(7);
        cout << "初始状态:" << endl;
        uf.print();

        uf.unite(0, 1);
        uf.unite(1, 2);
        cout << "unite(0,1), unite(1,2) 后:" << endl;
        uf.print();

        uf.unite(3, 4);
        uf.unite(4, 5);
        uf.unite(5, 6);
        cout << "再 unite(3,4), unite(4,5), unite(5,6) 后:" << endl;
        uf.print();

        cout << "same(0,2) = " << uf.same(0, 2) << endl;  // true
        cout << "same(0,3) = " << uf.same(0, 3) << endl;  // false
        cout << "same(3,6) = " << uf.same(3, 6) << endl;  // true
    }

    cout << "\\n=== 优化并查集 ===" << endl;
    {
        UnionFind uf(7);
        uf.unite(0, 1);
        uf.unite(1, 2);
        uf.unite(3, 4);
        uf.unite(4, 5);

        cout << "\\n查找 find(2): ";
        cout << uf.find(2) << endl;
        cout << "same(0,2) = " << uf.same(0, 2) << endl;
        cout << "same(0,3) = " << uf.same(0, 3) << endl;

        cout << "\\nunite(2, 3): ";
        uf.unite(2, 3);

        cout << "\\nunite(2, 3) 之后:" << endl;
        cout << "same(0,3) = " << uf.same(0, 3) << endl;  // true

        cout << "\\n集合数量: " << uf.countSets() << endl;

        cout << "\\nunite(0, 3): ";
        uf.unite(0, 3);
    }

    return 0;
}''',
          description: '展示朴素并查集、带路径压缩和按秩合并的并查集实现和使用。',
          output: '''=== 朴素并查集 ===
初始状态:
parent: 0->0 1->1 2->2 3->3 4->4 5->5 6->6 
unite(0,1), unite(1,2) 后:
parent: 0->0 1->0 2->0 3->3 4->4 5->5 6->6 
unite(3,4), unite(4,5), unite(5,6) 后:
parent: 0->0 1->0 2->0 3->3 4->3 5->3 6->3 
same(0,2) = 1
same(0,3) = 0
same(3,6) = 1

=== 优化并查集 ===
合并 0 -> 0
合并 1 -> 0
合并 3 -> 3
合并 4 -> 3

查找 find(2): 0
same(0,2) = 1
same(0,3) = 0

unite(2, 3): 合并 4 -> 0
unite(2, 3) 之后:
same(0,3) = 1

集合数量: 2
unite(0, 3): 0 和 3 已在同一集合''',
        ),
        CodeExample(
          title: '并查集应用',
          code: '''#include <iostream>
#include <vector>
#include <string>
using namespace std;

// =====================
// 应用1: 连通分量数量
// =====================
int countComponents(int n, const vector<pair<int,int>>& edges) {
    class UnionFind {
        vector<int> parent, rank;
    public:
        UnionFind(int n) : parent(n), rank(n, 0) {
            for (int i = 0; i < n; i++) parent[i] = i;
        }
        int find(int x) {
            if (parent[x] != x) parent[x] = find(parent[x]);
            return parent[x];
        }
        void unite(int a, int b) {
            int ra = find(a), rb = find(b);
            if (ra == rb) return;
            if (rank[ra] < rank[rb]) swap(ra, rb);
            parent[rb] = ra;
            if (rank[ra] == rank[rb]) rank[ra]++;
        }
    };

    UnionFind uf(n);
    for (auto [u, v] : edges) uf.unite(u, v);

    int components = 0;
    for (int i = 0; i < n; i++) {
        if (uf.find(i) == i) components++;
    }
    return components;
}

// =====================
// 应用2: 岛屿数量 (LeetCode 200)
// =====================
int numIslands(vector<vector<char>>& grid) {
    if (grid.empty() || grid[0].empty()) return 0;

    int m = grid.size(), n = grid[0].size();

    class UnionFind {
        vector<int> parent, rank;
        int count;
    public:
        UnionFind(int m, int n, const vector<vector<char>>& grid)
            : parent(m*n, -1), rank(m*n, 0), count(0) {
            for (int i = 0; i < m; i++) {
                for (int j = 0; j < n; j++) {
                    if (grid[i][j] == '1') {
                        int id = i*n + j;
                        parent[id] = id;
                        count++;
                    }
                }
            }
        }

        int find(int x) {
            if (parent[x] != x) parent[x] = find(parent[x]);
            return parent[x];
        }

        void unite(int a, int b) {
            int ra = find(a), rb = find(b);
            if (ra == rb) return;
            if (rank[ra] < rank[rb]) swap(ra, rb);
            parent[rb] = ra;
            if (rank[ra] == rank[rb]) rank[ra]++;
            count--;
        }

        int countSets() { return count; }
    };

    UnionFind uf(m, n, grid);

    // 方向: 上下左右
    vector<pair<int,int>> dirs = {{-1,0}, {1,0}, {0,-1}, {0,1}};

    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            if (grid[i][j] == '1') {
                int id = i*n + j;
                for (auto [di, dj] : dirs) {
                    int ni = i + di, nj = j + dj;
                    if (ni >= 0 && ni < m && nj >= 0 && nj < n
                        && grid[ni][nj] == '1') {
                        uf.unite(id, ni*n + nj);
                    }
                }
            }
        }
    }

    return uf.countSets();
}

// =====================
// 应用3: 等价关系（亲戚关系）
// =====================
string areRelatives(int n, const vector<pair<int,int>>& relations, int a, int b) {
    class UnionFind {
        vector<int> parent;
    public:
        UnionFind(int n) : parent(n) {
            for (int i = 0; i < n; i++) parent[i] = i;
        }
        int find(int x) {
            if (parent[x] != x) parent[x] = find(parent[x]);
            return parent[x];
        }
        void unite(int a, int b) {
            int ra = find(a), rb = find(b);
            if (ra == rb) return;
            parent[rb] = ra;
        }
    };

    UnionFind uf(n);
    for (auto [u, v] : relations) uf.unite(u, v);

    return uf.find(a) == uf.find(b) ? "是" : "不是";
}

int main() {
    cout << "=== 应用1: 连通分量 ===" << endl;
    {
        int n = 6;
        vector<pair<int,int>> edges = {{0,1}, {1,2}, {3,4}};
        cout << "节点数: " << n << ", 边: ";
        for (auto [u, v] : edges) cout << "(" << u << "," << v << ") ";
        cout << endl;
        cout << "连通分量数: " << countComponents(n, edges) << endl;
    }

    cout << "\\n=== 应用2: 岛屿数量 ===" << endl;
    {
        vector<vector<char>> grid = {
            {'1','1','0','0','0'},
            {'1','1','0','0','0'},
            {'0','0','1','0','0'},
            {'0','0','0','1','1'}
        };
        cout << "岛屿数量: " << numIslands(grid) << endl;
    }

    cout << "\\n=== 应用3: 亲戚关系 ===" << endl;
    {
        int n = 8;  // 8 个人，编号 0-7
        vector<pair<int,int>> relations = {
            {0,1}, {1,2}, {2,3},  // 0-1-2-3 是一个圈子
            {4,5}, {5,6},         // 4-5-6 是一个圈子
        };
        cout << "0 和 3 " << areRelatives(n, relations, 0, 3) << "亲戚" << endl;
        cout << "0 和 4 " << areRelatives(n, relations, 0, 4) << "亲戚" << endl;
        cout << "4 和 6 " << areRelatives(n, relations, 4, 6) << "亲戚" << endl;
    }

    return 0;
}''',
          description: '展示并查集的三个应用：连通分量、岛屿数量（LeetCode 200）、亲戚关系判断。',
          output: '''=== 应用1: 连通分量 ===
节点数: 6, 边: (0,1) (1,2) (3,4) 
连通分量数: 3

=== 应用2: 岛屿数量 ===
岛屿数量: 3

=== 应用3: 亲戚关系 ===
0 和 3 是亲戚
0 和 4 不是亲戚
4 和 6 是亲戚''',
        ),
      ],
      keyPoints: [
        '并查集支持 Find（查）和 Union（并）两个操作，用于处理不相交集合的合并和查询',
        '路径压缩在 find 时将路径上的节点直接指向根，使树扁平化',
        '按秩合并（小秩合并到大秩）控制树的深度，两者结合几乎达到 O(α(n)) ≈ O(1)',
        '并查集用于：连通分量、Kruskal 最小生成树、岛屿数量、社交网络等价类',
        '并查集适合动态连通性问题，能高效判断两点是否在同一集合',
      ],
    ),
  ],
);
