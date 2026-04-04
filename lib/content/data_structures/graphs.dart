// Graph Data Structure Course Content
import '../course_data.dart';

/// Graph Data Structure Chapter
const chapterGraphDataStructure = CourseChapter(
  id: 'datastruct_graph',
  title: '图',
  description: '学习图的基本概念、存储结构（邻接表、邻接矩阵）以及图的遍历算法（BFS、DFS）。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    // Lesson 1: Graph Basics
    CourseLesson(
      id: 'graph_basics',
      title: '图的基本概念',
      content: '''# 图的基本概念

图（Graph）是一种重要的非线性数据结构，由顶点（Vertex）和边（Edge）组成，用于描述事物之间的关联关系。

## 图的定义

图 G 由两个集合组成：
- **V(G)**：顶点的有限非空集合
- **E(G)**：边的有限集合

记作 G = (V, E)

## 图的分类

### 1. 无向图 vs 有向图

**无向图**：边没有方向，表示对称关系
```
A —— B
|     |
C —— D
```
顶点 A 和 B 之间的边记作 {A, B} 或 (A, B)

**有向图**：边有方向，表示非对称关系
```
A → B
↓   ↑
C ← D
```
从 A 指向 B 的边记作 <A, B>，A 为弧尾（Tail），B 为弧头（Head）

### 2. 完全图

**无向完全图**：任意两个顶点之间都存在边，含有 n 个顶点的无向完全图有 n(n-1)/2 条边

**有向完全图**：任意两个顶点之间都存在方向相反的两条弧，含有 n 个顶点的有向完全图有 n(n-1) 条边

### 3. 稠密图 vs 稀疏图

- **稠密图**：边数接近完全图
- **稀疏图**：边数远少于完全图（通常 E < V log V）

## 度（Degree）

- **无向图**：顶点的度 = 与该顶点相连的边数
- **有向图**：
  - 入度：以该顶点为弧头的弧数
  - 出度：以该顶点为弧尾的弧数
  - 度 = 入度 + 出度

## 路径（Path）

- **路径长度**：路径上边的数目
- **简单路径**：顶点不重复的路径
- **回路**：起点和终点相同的路径
- **连通图**：无向图中任意两个顶点之间都存在路径
- **强连通图**：有向图中任意两个顶点之间都存在双向路径

## 连通分量

**连通分量**是无向图中的极大连通子图。

含有 n 个顶点的无向图：
- 最多有 n(n-1)/2 条边（完全图）
- 至少需要 n-1 条边才能保证连通（生成树）
''',
      codeExamples: [
        CodeExample(
          title: '图的基本概念代码示例',
          code: '''#include <iostream>
#include <vector>
#include <string>
using namespace std;

// 图的顶点定义
struct Vertex {
    int id;              // 顶点编号
    string name;         // 顶点名称
    vector<int> neighbors; // 邻居顶点（邻接表）

    Vertex(int i, const string& n) : id(i), name(n) {}
};

int main() {
    // 创建无向图示例
    vector<Vertex> vertices;
    vertices.emplace_back(0, "A");
    vertices.emplace_back(1, "B");
    vertices.emplace_back(2, "C");
    vertices.emplace_back(3, "D");

    // 添加边：A-B, A-C, B-C, B-D, C-D
    vertices[0].neighbors = {1, 2};      // A 的邻居
    vertices[1].neighbors = {0, 2, 3};    // B 的邻居
    vertices[2].neighbors = {0, 1, 3};    // C 的邻居
    vertices[3].neighbors = {1, 2};      // D 的邻居

    // 打印每个顶点的度和邻居
    for (const auto& v : vertices) {
        cout << "顶点 " << v.name << " (度=" << v.neighbors.size() << "): ";
        for (int neighbor : v.neighbors) {
            cout << vertices[neighbor].name << " ";
        }
        cout << endl;
    }

    // 输出:
    // 顶点 A (度=2): B C
    // 顶点 B (度=3): A C D
    // 顶点 C (度=3): A B D
    // 顶点 D (度=2): B C
}''',
          description: '使用邻接表表示无向图，展示图的顶点和边的基本概念。',
          output: '''顶点 A (度=2): B C
顶点 B (度=3): A C D
顶点 C (度=3): A B D
顶点 D (度=2): B C''',
        ),
      ],
      keyPoints: [
        '图由顶点集 V 和边集 E 组成',
        '无向图边无方向，有向图边有方向',
        '顶点的度等于与其相连的边数',
        '连通图任意两点间存在路径',
      ],
    ),

    // Lesson 2: Adjacency Matrix
    CourseLesson(
      id: 'graph_adjacency_matrix',
      title: '邻接矩阵',
      content: '''# 邻接矩阵

邻接矩阵（Adjacency Matrix）是用一个二维数组来表示图的方法。

## 基本原理

对于含有 n 个顶点的图 G = (V, E)，邻接矩阵是一个 n × n 的二维数组 M：

**无向图**：
- M[i][j] = 1，表示顶点 i 和顶点 j 之间有边
- M[i][j] = 0，表示顶点 i 和顶点 j 之间无边

**有向图**：
- M[i][j] = 1，表示从顶点 i 到顶点 j 有一条弧
- M[i][j] = 0，表示不存在从 i 到 j 的弧

## 示例

无向图及其邻接矩阵：

```
  A B C D
A 0 1 1 0
B 1 0 1 1
C 1 1 0 1
D 0 1 1 0
```

**特点**：
- 矩阵是关于主对角线对称的（无向图）
- 对角线上的元素全为 0（无自环）
- 第 i 行（或列）中 1 的个数 = 顶点 i 的度（无向图）

有向图及其邻接矩阵：

```
  A B C D
A 0 1 0 0
B 0 0 1 1
C 1 0 0 0
D 0 0 1 0
```

**特点**：
- 矩阵不一定对称
- 第 i 行中 1 的个数 = 顶点 i 的出度
- 第 i 列中 1 的个数 = 顶点 i 的入度

## 优缺点

| 优点 | 缺点 |
|------|------|
| 实现简单，直观 | 空间复杂度 O(V²) |
| 判断两点是否相邻：O(1) | 遍历所有边：O(V²) |
| 方便找任一点的邻接点 | 不适合稀疏图 |

## 适用场景

- 稠密图（边数接近 V²）
- 需要频繁判断两点是否相邻
- 需要快速获取任一点的全部邻接点
''',
      codeExamples: [
        CodeExample(
          title: '邻接矩阵实现',
          code: '''#include <iostream>
#include <vector>
#include <iomanip>
using namespace std;

class AdjacencyMatrix {
private:
    vector<vector<int>> matrix;  // 邻接矩阵
    vector<string> vertices;     // 顶点名称
    int numVertices;

public:
    AdjacencyMatrix(const vector<string>& v) {
        numVertices = v.size();
        vertices = v;
        // 初始化 matrix，所有元素为 0
        matrix.assign(numVertices, vector<int>(numVertices, 0));
    }

    // 添加无向边
    void addUndirectedEdge(int i, int j) {
        if (i >= 0 && i < numVertices && j >= 0 && j < numVertices) {
            matrix[i][j] = 1;
            matrix[j][i] = 1;  // 对称
        }
    }

    // 添加有向边
    void addDirectedEdge(int i, int j) {
        if (i >= 0 && i < numVertices && j >= 0 && j < numVertices) {
            matrix[i][j] = 1;
        }
    }

    // 判断两个顶点之间是否有边
    bool hasEdge(int i, int j) const {
        return matrix[i][j] == 1;
    }

    // 获取顶点 i 的出度（有向图）
    int outDegree(int i) const {
        int count = 0;
        for (int j = 0; j < numVertices; j++) {
            if (matrix[i][j] == 1) count++;
        }
        return count;
    }

    // 获取顶点 i 的入度（有向图）
    int inDegree(int i) const {
        int count = 0;
        for (int j = 0; j < numVertices; j++) {
            if (matrix[j][i] == 1) count++;
        }
        return count;
    }

    // 打印邻接矩阵
    void print() const {
        cout << "   ";
        for (const string& v : vertices) {
            cout << setw(3) << v;
        }
        cout << endl;

        for (int i = 0; i < numVertices; i++) {
            cout << setw(3) << vertices[i];
            for (int j = 0; j < numVertices; j++) {
                cout << setw(3) << matrix[i][j];
            }
            cout << endl;
        }
    }
};

int main() {
    // 创建有向图：A -> B, A -> C, B -> C, C -> D
    AdjacencyMatrix graph({"A", "B", "C", "D"});
    graph.addDirectedEdge(0, 1);  // A -> B
    graph.addDirectedEdge(0, 2);  // A -> C
    graph.addDirectedEdge(1, 2);  // B -> C
    graph.addDirectedEdge(2, 3);  // C -> D

    graph.print();

    cout << "\\nA 的出度: " << graph.outDegree(0) << endl;
    cout << "A 的入度: " << graph.inDegree(0) << endl;
    cout << "C 的出度: " << graph.outDegree(2) << endl;
    cout << "C 的入度: " << graph.inDegree(2) << endl;
}''',
          description: '邻接矩阵的完整实现，包含添加边、查询边、计算度数等功能。',
          output: '''   A  B  C  D
  A  0  1  1  0
  B  0  0  1  0
  C  0  0  0  1
  D  0  0  0  0

A 的出度: 2
A 的入度: 0
C 的出度: 1
C 的入度: 2''',
        ),
      ],
      keyPoints: [
        '邻接矩阵是 n×n 的二维数组',
        '空间复杂度 O(V²)，适合稠密图',
        '判断两点是否相邻的时间复杂度 O(1)',
        '无向图的矩阵关于主对角线对称',
      ],
    ),

    // Lesson 3: Adjacency List
    CourseLesson(
      id: 'graph_adjacency_list',
      title: '邻接表',
      content: '''# 邻接表

邻接表（Adjacency List）是图的一种链式存储结构，对每个顶点建立一个链表，存储与其相邻的所有顶点。

## 基本原理

对于含有 n 个顶点的图：
- 创建一个大小为 n 的数组（或向量），每个元素是一个链表
- 第 i 个链表存储所有与顶点 i 相邻的顶点

**无向图**：顶点 i 的链表中存储所有与 i 有边相连的顶点
**有向图**：顶点 i 的链表中存储所有从 i 出发的弧指向的顶点（出边）

## 示例

```
  A → B → C
  ↓
  C → D
```

邻接表表示：
```
A: B → C
B: C
C: D
D: (空)
```

## 与邻接矩阵的对比

| 特征 | 邻接矩阵 | 邻接表 |
|------|----------|--------|
| 空间复杂度 | O(V²) | O(V + E) |
| 判断两点是否有边 | O(1) | O(V)（链表搜索）|
| 找某点的所有邻边 | O(V) | O(1)（直接遍历链表）|
| 适用场景 | 稠密图 | 稀疏图 |

## 适用场景

- 稀疏图（边数远少于 V²）
- 需要遍历某点的所有邻接边
- 图规模较大，需要节省空间
''',
      codeExamples: [
        CodeExample(
          title: '邻接表实现',
          code: '''#include <iostream>
#include <vector>
#include <list>
#include <queue>
using namespace std;

class AdjacencyList {
private:
    vector<list<int>> adjList;  // 邻接表
    vector<string> vertices;    // 顶点名称
    int numVertices;

public:
    AdjacencyList(const vector<string>& v) {
        numVertices = v.size();
        vertices = v;
        adjList.assign(numVertices, list<int>());
    }

    // 添加无向边
    void addUndirectedEdge(int i, int j) {
        if (i >= 0 && i < numVertices && j >= 0 && j < numVertices) {
            adjList[i].push_back(j);
            adjList[j].push_back(i);  // 双向添加
        }
    }

    // 添加有向边
    void addDirectedEdge(int i, int j) {
        if (i >= 0 && i < numVertices && j >= 0 && j < numVertices) {
            adjList[i].push_back(j);
        }
    }

    // 判断两个顶点之间是否有边
    bool hasEdge(int i, int j) const {
        for (int neighbor : adjList[i]) {
            if (neighbor == j) return true;
        }
        return false;
    }

    // 获取顶点 i 的所有邻居
    void getNeighbors(int i, vector<int>& neighbors) const {
        neighbors.clear();
        for (int neighbor : adjList[i]) {
            neighbors.push_back(neighbor);
        }
    }

    // 获取顶点 i 的度（无向图）
    int degree(int i) const {
        return adjList[i].size();
    }

    // 获取顶点 i 的出度（有向图）
    int outDegree(int i) const {
        return adjList[i].size();
    }

    // 打印邻接表
    void print() const {
        for (int i = 0; i < numVertices; i++) {
            cout << vertices[i] << ": ";
            for (int neighbor : adjList[i]) {
                cout << vertices[neighbor] << " -> ";
            }
            cout << "null" << endl;
        }
    }

    // 获取邻接表引用（供外部使用）
    const list<int>& getAdjList(int i) const {
        return adjList[i];
    }

    int getNumVertices() const { return numVertices; }
    const string& getVertexName(int i) const { return vertices[i]; }
};

int main() {
    // 创建无向图：A-B, A-C, B-C, B-D, C-D
    AdjacencyList graph({"A", "B", "C", "D"});
    graph.addUndirectedEdge(0, 1);  // A-B
    graph.addUndirectedEdge(0, 2);  // A-C
    graph.addUndirectedEdge(1, 2);  // B-C
    graph.addUndirectedEdge(1, 3);  // B-D
    graph.addUndirectedEdge(2, 3);  // C-D

    graph.print();

    cout << "\\n各顶点度数:" << endl;
    for (int i = 0; i < graph.getNumVertices(); i++) {
        cout << graph.getVertexName(i) << " 的度: "
             << graph.degree(i) << endl;
    }
}''',
          description: '邻接表的完整实现，支持添加边、查询邻居、计算度数。',
          output: '''A: B -> C -> null
B: A -> C -> D -> null
C: A -> B -> D -> null
D: B -> C -> null

各顶点度数:
A 的度: 2
B 的度: 3
C 的度: 3
D 的度: 2''',
        ),
      ],
      keyPoints: [
        '邻接表对每个顶点建立一个链表存储邻居',
        '空间复杂度 O(V + E)，适合稀疏图',
        '找某点的所有邻居比邻接矩阵更高效',
        '判断两点是否有边需要遍历链表',
      ],
    ),

    // Lesson 4: BFS
    CourseLesson(
      id: 'graph_bfs',
      title: '广度优先搜索 (BFS)',
      content: '''# 广度优先搜索 (BFS)

广度优先搜索（Breadth-First Search，BFS）是一种按照"层次"遍历图的算法，从起点开始，先访问所有距离起点为 1 的顶点，再访问距离为 2 的顶点，以此类推。

## 算法原理

BFS 使用**队列**（Queue）来存储待访问的顶点：

1. 将起始顶点放入队列
2. 从队列中取出一个顶点，访问它
3. 将该顶点的所有**未访问过**的邻接顶点加入队列
4. 重复步骤 2-3，直到队列为空

## 算法步骤

对于下图，从顶点 A 开始 BFS：

```
    A
   / \\
  B   C
 / \\   \\
D   E - F
```

**遍历过程：**

| 步骤 | 操作 | 队列状态 | 访问顺序 |
|------|------|----------|----------|
| 1 | 将 A 入队 | [A] | - |
| 2 | 取出 A，访问，邻居 B,C 入队 | [B, C] | A |
| 3 | 取出 B，访问，邻居 A,D,E 入队（A 已访问）| [C, D, E] | A, B |
| 4 | 取出 C，访问，邻居 A,E,F 入队（A,E 已访问）| [D, E, F] | A, B, C |
| 5 | 取出 D，访问（D 无新邻居）| [E, F] | A, B, C, D |
| 6 | 取出 E，访问，邻居 B,C,D,F 入队（都已访问）| [F] | A, B, C, D, E |
| 7 | 取出 F，访问，邻居 C,E 已访问 | [] | A, B, C, D, E, F |

**访问顺序**：A → B → C → D → E → F

## 复杂度分析

| 复杂度 | 值 |
|--------|-----|
| 时间复杂度 | O(V + E) — 每个顶点访问一次，每条边检查一次 |
| 空间复杂度 | O(V) — 队列最多存储所有顶点 |

## BFS 的应用

1. **最短路径**：在无权图中，BFS 可以找到从起点到任意点的最短路径
2. **连通分量**：找出图中的所有连通分量
3. **层次遍历**：按层次顺序访问节点
4. **二分图判定**：判断图是否为二分图
5. **图的着色**：为图的顶点着色
''',
      codeExamples: [
        CodeExample(
          title: 'BFS 实现',
          code: '''#include <iostream>
#include <vector>
#include <queue>
#include <unordered_set>
using namespace std;

class Graph {
public:
    vector<vector<int>> adj;  // 邻接表

    Graph(int n) : adj(n) {}

    void addEdge(int u, int v, bool directed = false) {
        adj[u].push_back(v);
        if (!directed) {
            adj[v].push_back(u);
        }
    }

    // BFS 遍历，从 start 开始
    void bfs(int start) const {
        vector<bool> visited(adj.size(), false);
        queue<int> q;

        // 1. 将起始顶点入队
        visited[start] = true;
        q.push(start);

        cout << "BFS 遍历顺序: ";
        while (!q.empty()) {
            // 2. 取出队首顶点
            int u = q.front();
            q.pop();

            // 3. 访问（输出）该顶点
            cout << u << " ";

            // 4. 将所有未访问的邻接顶点入队
            for (int v : adj[u]) {
                if (!visited[v]) {
                    visited[v] = true;
                    q.push(v);
                }
            }
        }
        cout << endl;
    }

    // BFS 求单源最短路径（无权图）
    vector<int> shortestPath(int start) const {
        vector<bool> visited(adj.size(), false);
        vector<int> dist(adj.size(), -1);  // 距离数组
        queue<int> q;

        visited[start] = true;
        dist[start] = 0;
        q.push(start);

        while (!q.empty()) {
            int u = q.front();
            q.pop();

            for (int v : adj[u]) {
                if (!visited[v]) {
                    visited[v] = true;
                    dist[v] = dist[u] + 1;
                    q.push(v);
                }
            }
        }
        return dist;
    }
};

int main() {
    // 创建图：
    //     0
    //    / \\
    //   1   2
    //  / \\   \\
    // 3   4 - 5
    Graph g(6);
    g.addEdge(0, 1);
    g.addEdge(0, 2);
    g.addEdge(1, 3);
    g.addEdge(1, 4);
    g.addEdge(2, 5);
    g.addEdge(4, 5);

    g.bfs(0);

    // 打印从顶点 0 到各点的最短距离
    vector<int> dist = g.shortestPath(0);
    cout << "从顶点 0 到各点的最短距离:" << endl;
    for (int i = 0; i < dist.size(); i++) {
        cout << "  到顶点 " << i << ": " << dist[i] << endl;
    }
}''',
          description: 'BFS 完整实现，包含遍历和最短路径计算。',
          output: '''BFS 遍历顺序: 0 1 2 3 4 5
从顶点 0 到各点的最短距离:
  到顶点 0: 0
  到顶点 1: 1
  到顶点 2: 1
  到顶点 3: 2
  到顶点 4: 2
  到顶点 5: 2''',
        ),
      ],
      keyPoints: [
        'BFS 使用队列，按层次遍历图',
        '时间复杂度 O(V + E)，空间复杂度 O(V)',
        'BFS 可以找到无权图中的最短路径',
        '需要 visited 数组防止重复访问',
      ],
    ),

    // Lesson 5: DFS
    CourseLesson(
      id: 'graph_dfs',
      title: '深度优先搜索 (DFS)',
      content: '''# 深度优先搜索 (DFS)

深度优先搜索（Depth-First Search，DFS）是一种"一条路走到黑"的搜索策略，沿着一条路径尽可能深地探索，直到无法继续为止，然后回溯到最近的分支点，继续探索。

## 算法原理

DFS 可以使用**递归**或**栈**实现：

**递归版本**：
1. 访问起始顶点
2. 对每个未访问的邻接顶点，递归调用 DFS
3. 直到所有可达顶点都被访问

**栈版本**：
1. 将起始顶点入栈
2. 弹出栈顶顶点，访问它
3. 将所有未访问的邻接顶点入栈
4. 重复步骤 2-3，直到栈为空

## 算法步骤

对于下图，从顶点 A 开始 DFS：

```
    A
   / \\
  B   C
 / \\   \\
D   E - F
```

**遍历过程（递归）**：

1. 访问 A
2. 递归访问 A 的第一个邻接点 B
   - 访问 B
   - 递归访问 B 的第一个邻接点 D
     - 访问 D（D 无新邻接点，返回）
   - 递归访问 D 之后，访问 E
     - 访问 E
3. 回溯到 B，继续访问 C（C 未访问）
   - 访问 C
   - 递归访问 F
     - 访问 F（F 无新邻接点，返回）

**可能的访问顺序**：A → B → D → E → C → F
**（取决于邻接表的存储顺序）

## 复杂度分析

| 复杂度 | 值 |
|--------|-----|
| 时间复杂度 | O(V + E) — 每个顶点访问一次，每条边检查一次 |
| 空间复杂度 | O(V) — 递归栈或显式栈 |

## DFS 的应用

1. **连通分量**：找出图中的所有连通分量
2. **拓扑排序**：对有向无环图（DAG）进行排序
3. **检测环**：判断图是否有环
4. **路径查找**：找出两点之间是否存在路径
5. **迷宫求解**：使用回溯法解决迷宫问题
6. **强连通分量**：在有向图中找强连通分量
''',
      codeExamples: [
        CodeExample(
          title: 'DFS 实现（递归版）',
          code: '''#include <iostream>
#include <vector>
#include <stack>
using namespace std;

class Graph {
public:
    vector<vector<int>> adj;

    Graph(int n) : adj(n) {}

    void addEdge(int u, int v, bool directed = false) {
        adj[u].push_back(v);
        if (!directed) {
            adj[v].push_back(u);
        }
    }

    // DFS 递归版本
    void dfsRecursive(int start) const {
        vector<bool> visited(adj.size(), false);
        cout << "DFS 递归遍历: ";
        _dfsHelper(start, visited);
        cout << endl;
    }

    void _dfsHelper(int u, vector<bool>& visited) const {
        visited[u] = true;
        cout << u << " ";
        for (int v : adj[u]) {
            if (!visited[v]) {
                _dfsHelper(v, visited);
            }
        }
    }

    // DFS 栈版本（非递归）
    void dfsIterative(int start) const {
        vector<bool> visited(adj.size(), false);
        stack<int> st;
        cout << "DFS 栈遍历: ";

        st.push(start);
        while (!st.empty()) {
            int u = st.top();
            st.pop();

            if (visited[u]) continue;
            visited[u] = true;
            cout << u << " ";

            // 注意：逆序入栈保证顺序
            for (int i = adj[u].size() - 1; i >= 0; i--) {
                int v = adj[u][i];
                if (!visited[v]) {
                    st.push(v);
                }
            }
        }
        cout << endl;
    }

    // 检测图中是否有环（适用于无向图）
    bool hasCycle() const {
        vector<bool> visited(adj.size(), false);
        for (int i = 0; i < adj.size(); i++) {
            if (!visited[i]) {
                if (_hasCycleHelper(i, visited, -1)) {
                    return true;
                }
            }
        }
        return false;
    }

    bool _hasCycleHelper(int u, vector<bool>& visited, int parent) const {
        visited[u] = true;
        for (int v : adj[u]) {
            if (!visited[v]) {
                if (_hasCycleHelper(v, visited, u)) {
                    return true;
                }
            } else if (v != parent) {
                // 如果邻接点已访问且不是父节点，则有环
                return true;
            }
        }
        return false;
    }
};

int main() {
    // 创建图（有环）：
    //     0
    //    / \\
    //   1   2
    //  / \\   \\
    // 3   4 - 5
    Graph g(6);
    g.addEdge(0, 1);
    g.addEdge(0, 2);
    g.addEdge(1, 3);
    g.addEdge(1, 4);
    g.addEdge(2, 5);
    g.addEdge(4, 5);  // 形成一个环: 1-4-5-2-1

    g.dfsRecursive(0);
    g.dfsIterative(0);
    cout << "图是否有环: " << (g.hasCycle() ? "是" : "否") << endl;
}''',
          description: 'DFS 的递归和栈两种实现，以及环检测应用。',
          output: '''DFS 递归遍历: 0 1 3 4 5 2
DFS 栈遍历: 0 2 5 4 1 3
图是否有环: 是''',
        ),
      ],
      keyPoints: [
        'DFS 使用栈（或递归）沿路径深入探索',
        '时间复杂度 O(V + E)，空间复杂度 O(V)',
        '适合路径查找、环检测等问题',
        '需要 visited 数组和 parent 参数配合',
      ],
    ),
  ],
);
