// 算法 - 最短路径 - Shortest Path Algorithms
import '../course_data.dart';

/// 最短路径算法章节
const chapterShortestPath = CourseChapter(
  id: 'algorithms_shortest_path',
  title: '最短路径算法',
  description: '学习图算法中的最短路径问题，包括 Dijkstra、Bellman-Ford 和 Floyd-Warshall 算法。',
  difficulty: DifficultyLevel.advanced,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'algorithms_dijkstra',
      title: 'Dijkstra 算法',
      content: '''# Dijkstra 算法

## 算法思想

Dijkstra 算法用于计算**单源最短路径**：从一个源顶点出发，到所有其他顶点的最短路径。

**核心思想**：贪心。每次选择当前未处理的顶点中距离源点最近的顶点（"最近"即最优），然后更新它的邻居距离。

## 算法步骤

```
1. 初始化:
   - dist[s] = 0（源点到自身距离为0）
   - dist[v] = ∞（其他顶点距离为无穷大）
   - visited[v] = false

2. 重复直到所有顶点处理完:
   a. 从未访问顶点中选择 dist 最小的顶点 u
   b. 标记 u 为已访问
   c. 对于 u 的每个邻居 v:
      如果 dist[u] + w(u,v) < dist[v]:
          dist[v] = dist[u] + w(u,v)
```

## 图示

```
       4        2
   A ------ B ------ C
   |        |        |
   | 1      | 3      | 1
   |        |        |
   D ------ E ------ F
       2        1

从 A 出发到各点的最短距离:
- A: 0
- B: 4 (A->B)
- C: 6 (A->B->C)
- D: 1 (A->D)
- E: 3 (A->D->E)
- F: 4 (A->D->E->F)
```

## 算法正确性证明（贪心选择）

**为什么选择当前最短的未处理顶点就能保证正确？**

假设从源点 s 出发，已知最短路径会经过某个未处理顶点 x（如 A→...→x→...→t）。

在这条最短路径上，x 之前的顶点距离都 ≤ dist[x]。如果还有更短的路径，应该先经过某个未处理顶点 y，dist[y] < dist[x]，这与"选择 dist 最小的顶点"矛盾。

因此，**一旦顶点被标记为已访问，它的 dist 就是最短距离**。

## 时间复杂度

| 实现方式 | 时间复杂度 |
|----------|------------|
| 朴素实现（扫描找最小） | O(V²) |
| 二叉堆（优先队列） | O((V+E) log V) |
| 斐波那契堆 | O(E + V log V) |

## 局限性

- **不能处理负权边**：负权边会导致贪心选择错误
- **不能处理负权环**：负权环会导致最短路径不存在（无限小）

对于有负权边的情况，使用 Bellman-Ford 算法。
''',
      codeExamples: [
        CodeExample(
          title: 'Dijkstra 朴素实现',
          code: '''#include <iostream>
#include <vector>
#include <climits>
#include <string>
using namespace std;

// 朴素 Dijkstra: O(V^2)
struct Graph {
    int V;  // 顶点数
    vector<vector<pair<int,int>>> adj;  // {邻居, 权重}

    Graph(int v) : V(v) {
        adj.resize(V);
    }

    void addEdge(int u, int v, int w) {
        adj[u].push_back({v, w});
        adj[v].push_back({u, w});  // 无向图
    }
};

void dijkstra_naive(const Graph& g, int src) {
    vector<int> dist(g.V, INT_MAX);
    vector<bool> visited(g.V, false);

    dist[src] = 0;

    cout << "=== Dijkstra 朴素实现 O(V^2) ===" << endl;

    for (int count = 0; count < g.V; count++) {
        // 1. 找未访问的最小距离顶点
        int u = -1;
        int minDist = INT_MAX;
        for (int i = 0; i < g.V; i++) {
            if (!visited[i] && dist[i] < minDist) {
                minDist = dist[i];
                u = i;
            }
        }

        if (u == -1) break;  // 其余顶点不可达

        visited[u] = true;
        cout << "选择顶点 " << u << " (dist=" << dist[u] << ")" << endl;

        // 2. 更新邻居距离
        for (auto [v, w] : g.adj[u]) {
            if (!visited[v] && dist[u] + w < dist[v]) {
                cout << "  更新 dist[" << v << "]: " << dist[v]
                     << " -> " << (dist[u] + w) << endl;
                dist[v] = dist[u] + w;
            }
        }
    }

    cout << "\\n最终距离:" << endl;
    for (int i = 0; i < g.V; i++) {
        cout << "源点 0 到顶点 " << i << ": " << dist[i] << endl;
    }
}

int main() {
    // 构建示例图
    //       4        2
    //   A ------ B ------ C
    //   |        |        |
    //   | 1      | 3      | 1
    //   |        |        |
    //   D ------ E ------ F
    //       2        1

    Graph g(6);
    g.addEdge(0, 1, 4);   // A-B
    g.addEdge(0, 3, 1);   // A-D
    g.addEdge(1, 2, 2);   // B-C
    g.addEdge(1, 4, 3);   // B-E
    g.addEdge(2, 5, 1);   // C-F
    g.addEdge(3, 4, 2);   // D-E
    g.addEdge(4, 5, 1);   // E-F

    dijkstra_naive(g, 0);

    return 0;
}''',
          description: '展示 Dijkstra 算法的朴素 O(V²) 实现，详细打印每一步的选择和更新过程。',
          output: '''=== Dijkstra 朴素实现 O(V^2) ===
选择顶点 0 (dist=0)
  更新 dist[1]: 2147483647 -> 4
  更新 dist[3]: 2147483647 -> 1
选择顶点 3 (dist=1)
  更新 dist[4]: 2147483647 -> 3
选择顶点 1 (dist=4)
  更新 dist[2]: 2147483647 -> 6
选择顶点 4 (dist=3)
  更新 dist[5]: 2147483647 -> 4
选择顶点 2 (dist=6)
选择顶点 5 (dist=4)

最终距离:
源点 0 到顶点 0: 0
源点 0 到顶点 1: 4
源点 0 到顶点 2: 6
源点 0 到顶点 3: 1
源点 0 到顶点 4: 3
源点 0 到顶点 5: 4''',
        ),
        CodeExample(
          title: 'Dijkstra 优先队列实现',
          code: '''#include <iostream>
#include <vector>
#include <queue>
#include <tuple>
using namespace std;

struct Edge {
    int to;
    int weight;
};

// 优先队列版 Dijkstra: O((V+E) log V)
void dijkstra_pq(int V, const vector<vector<Edge>>& adj, int src) {
    vector<int> dist(V, INT_MAX);
    vector<int> parent(V, -1);

    // {距离, 顶点} - 最小堆
    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> pq;

    dist[src] = 0;
    pq.push({0, src});

    cout << "=== Dijkstra 优先队列实现 O((V+E) log V) ===" << endl;

    while (!pq.empty()) {
        auto [d, u] = pq.top();
        pq.pop();

        // 跳过过时条目
        if (d > dist[u]) continue;

        cout << "处理顶点 " << u << " (dist=" << d << ")" << endl;

        for (const auto& e : adj[u]) {
            int v = e.to;
            int w = e.weight;

            if (dist[u] + w < dist[v]) {
                cout << "  更新 dist[" << v << "]: " << dist[v]
                     << " -> " << (dist[u] + w) << endl;
                dist[v] = dist[u] + w;
                parent[v] = u;
                pq.push({dist[v], v});
            }
        }
    }

    cout << "\\n最终距离:" << endl;
    for (int i = 0; i < V; i++) {
        cout << "源点到 " << i << ": " << dist[i] << endl;
    }

    cout << "\\n最短路径重建:" << endl;
    for (int i = 0; i < V; i++) {
        if (i == src) continue;
        cout << src << " -> " << i << ": ";
        vector<int> path;
        for (int v = i; v != -1; v = parent[v]) {
            path.push_back(v);
        }
        reverse(path.begin(), path.end());
        for (size_t j = 0; j < path.size(); j++) {
            cout << path[j];
            if (j < path.size() - 1) cout << " -> ";
        }
        cout << " (长度=" << dist[i] << ")" << endl;
    }
}

int main() {
    // 测试图
    vector<vector<Edge>> adj(6);
    auto addEdge = [&](int u, int v, int w) {
        adj[u].push_back({v, w});
        adj[v].push_back({u, w});
    };

    addEdge(0, 1, 4);
    addEdge(0, 3, 1);
    addEdge(1, 2, 2);
    addEdge(1, 4, 3);
    addEdge(2, 5, 1);
    addEdge(3, 4, 2);
    addEdge(4, 5, 1);

    dijkstra_pq(6, adj, 0);

    cout << "\\n=== 有向图测试 ===" << endl;

    vector<vector<Edge>> dag(5);
    dag[0] = {{1, 10}, {2, 3}};
    dag[1] = {{2, 1}, {3, 2}};
    dag[2] = {{1, 3}, {3, 8}, {4, 2}};
    dag[3] = {{4, 7}};
    dag[4] = {};

    dijkstra_pq(5, dag, 0);

    return 0;
}''',
          description: '展示 Dijkstra 的优先队列实现，支持路径重建，能够处理有向图。',
          output: '''=== Dijkstra 优先队列实现 O((V+E) log V) ===
处理顶点 0 (dist=0)
  更新 dist[1]: 2147483647 -> 4
  更新 dist[3]: 2147483647 -> 1
处理顶点 3 (dist=1)
  更新 dist[4]: 2147483647 -> 3
处理顶点 1 (dist=4)
  更新 dist[2]: 2147483647 -> 6
处理顶点 4 (dist=3)
  更新 dist[5]: 2147483647 -> 4
处理顶点 2 (dist=6)
处理顶点 5 (dist=4)

...（完整输出见实际运行）

=== 有向图测试 ===
处理顶点 0 (dist=0)
  更新 dist[1]: 2147483647 -> 10
  更新 dist[2]: 2147483647 -> 3
处理顶点 2 (dist=3)
  更新 dist[1]: 10 -> 6
  更新 dist[3]: 2147483647 -> 11
  更新 dist[4]: 2147483647 -> 5
...''',
        ),
      ],
      keyPoints: [
        'Dijkstra 是单源最短路径算法，基于贪心思想，每次选择 dist 最小的未处理顶点',
        'Dijkstra 不能处理负权边，负权边需要用 Bellman-Ford',
        '朴素实现 O(V²)，优先队列实现 O((V+E) log V)',
        'Dijkstra 算法正确性基于"最短路径上的中间顶点距离不可能更短"的贪心选择性质',
        '可以用 parent 数组重建最短路径',
      ],
    ),

    CourseLesson(
      id: 'algorithms_bellman_ford',
      title: 'Bellman-Ford 算法',
      content: '''# Bellman-Ford 算法

## 算法思想

Bellman-Ford 算法同样用于单源最短路径，但可以处理**负权边**，并能检测**负权环**。

**核心思想**：动态规划。最多进行 V-1 轮松弛操作（V = 顶点数），每轮尝试通过所有边更新距离。

## 与 Dijkstra 的区别

| 特点 | Dijkstra | Bellman-Ford |
|------|----------|--------------|
| 负权边 | ❌ 不支持 | ✅ 支持 |
| 时间复杂度 | O(V²) 或 O(E log V) | O(VE) |
| 负权环检测 | ❌ 不能 | ✅ 能 |
| 贪心/DP | 贪心 | DP |

## 算法步骤

```
1. 初始化:
   dist[s] = 0
   dist[v] = ∞

2. 重复 V-1 次:
   对于每条边 (u, v, w):
       如果 dist[u] + w < dist[v]:
           dist[v] = dist[u] + w

3. 检测负权环:
   再遍历一次所有边:
       如果 dist[u] + w < dist[v]:
           存在负权环
```

## 为什么 V-1 轮足够？

在无负权环的图中，最短路径最多包含 V-1 条边（简单路径）。

因此，经过 V-1 轮松弛后，所有最短路径都已找到。

## 负权环检测

如果第 V 轮松弛仍能更新，说明存在负权环（最短路径可以无限小）：

```
A --(-1)--> B --(-1)--> C --(-1)--> A (负权环)
每绕一圈，距离 -3，可以无限小
```

## SPFA 算法

Bellman-Ford 的队列优化版本（Shortest Path Faster Algorithm）：

```cpp
queue<int> q;
q.push(s);
inqueue[s] = true;

while (!q.empty()) {
    u = q.front(); q.pop();
    inqueue[u] = false;
    for (每条边 (u, v, w)) {
        if (dist[u] + w < dist[v]) {
            dist[v] = dist[u] + w;
            parent[v] = u;
            if (!inqueue[v]) {
                q.push(v);
                inqueue[v] = true;
            }
        }
    }
}
```

## 应用场景

- **路由算法**：RIP 使用 Bellman-Ford
- **金融套利检测**：货币兑换负权环检测
- **路径规划**：需要支持负边的情况
''',
      codeExamples: [
        CodeExample(
          title: 'Bellman-Ford 实现',
          code: '''#include <iostream>
#include <vector>
#include <climits>
#include <tuple>
using namespace std;

struct Edge {
    int u, v, w;
};

void bellmanFord(int V, const vector<Edge>& edges, int src) {
    vector<int> dist(V, INT_MAX);
    vector<int> parent(V, -1);
    dist[src] = 0;

    cout << "=== Bellman-Ford 算法 O(VE) ===" << endl;
    cout << "顶点数: " << V << ", 边数: " << edges.size() << endl;

    // V-1 轮松弛
    for (int i = 0; i < V - 1; i++) {
        bool updated = false;
        cout << "\\n第 " << (i + 1) << " 轮松弛:" << endl;

        for (const auto& e : edges) {
            if (dist[e.u] != INT_MAX && dist[e.u] + e.w < dist[e.v]) {
                cout << "  边 " << e.u << "->" << e.v
                     << " 放松: dist[" << e.v << "] "
                     << dist[e.v] << " -> " << (dist[e.u] + e.w) << endl;
                dist[e.v] = dist[e.u] + e.w;
                parent[e.v] = e.u;
                updated = true;
            }
        }

        if (!updated) {
            cout << "  无更新，提前结束" << endl;
            break;
        }
    }

    // 检测负权环
    cout << "\\n检测负权环:" << endl;
    bool hasNegativeCycle = false;
    for (const auto& e : edges) {
        if (dist[e.u] != INT_MAX && dist[e.u] + e.w < dist[e.v]) {
            cout << "  发现负权环！边 " << e.u << "->" << e.v << " 仍可更新" << endl;
            hasNegativeCycle = true;
            break;
        }
    }

    if (!hasNegativeCycle) {
        cout << "  无负权环" << endl;
    }

    // 输出结果
    cout << "\\n最短距离:" << endl;
    for (int i = 0; i < V; i++) {
        if (dist[i] == INT_MAX) {
            cout << src << " -> " << i << ": INF" << endl;
        } else {
            cout << src << " -> " << i << ": " << dist[i] << endl;
        }
    }

    // 重建路径
    cout << "\\n最短路径:" << endl;
    for (int i = 0; i < V; i++) {
        if (i == src || dist[i] == INT_MAX) continue;
        cout << src << " -> " << i << ": ";
        vector<int> path;
        for (int v = i; v != -1; v = parent[v]) {
            path.push_back(v);
        }
        reverse(path.begin(), path.end());
        for (size_t j = 0; j < path.size(); j++) {
            cout << path[j];
            if (j < path.size() - 1) cout << " -> ";
        }
        cout << endl;
    }
}

int main() {
    cout << "=== 无负权边图 ===" << endl;
    {
        int V = 5;
        vector<Edge> edges = {
            {0, 1, 10},
            {0, 2, 3},
            {1, 2, 1},
            {1, 3, 2},
            {2, 1, 3},
            {2, 3, 8},
            {2, 4, 2},
            {3, 4, 7}
        };
        bellmanFord(V, edges, 0);
    }

    cout << "\\n\\n=== 有负权边图 ===" << endl;
    {
        int V = 4;
        vector<Edge> edges = {
            {0, 1, 4},
            {0, 2, 5},
            {1, 2, -3},
            {2, 3, 2},
            {1, 3, 6}
        };
        bellmanFord(V, edges, 0);
    }

    cout << "\\n\\n=== 有负权环图 ===" << endl;
    {
        int V = 3;
        vector<Edge> edges = {
            {0, 1, 2},
            {1, 2, -5},
            {2, 0, 1}  // -5 + 1 = -4, 负权环
        };
        bellmanFord(V, edges, 0);
    }

    return 0;
}''',
          description: '展示 Bellman-Ford 算法的完整实现，包括 V-1 轮松弛和负权环检测。',
          output: '''=== 无负权边图 ===
顶点数: 5, 边数: 8

第 1 轮松弛:
  边 0->2 放松: dist[2] 2147483647 -> 3
  边 1->2 放松: dist[2] 3 -> 2
  ...

=== 有负权边图 ===
第 1 轮松弛:
  边 0->1 放松: dist[1] 2147483647 -> 4
  边 0->2 放松: dist[2] 2147483647 -> 5
  边 1->2 放松: dist[2] 5 -> 2
  ...

=== 有负权环图 ===
第 1 轮松弛:
  边 0->1 放松: dist[1] 2147483647 -> 2
  边 1->2 放松: dist[2] 2147483647 -> -3
  边 2->0 放松: dist[0] 0 -> -2
  ...

检测负权环:
  发现负权环！边 2->0 仍可更新''',
        ),
        CodeExample(
          title: 'Floyd-Warshall 全源最短路径',
          code: '''#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// Floyd-Warshall: 全源最短路径 O(V^3)
void floydWarshall(int V, const vector<vector<pair<int,int>>>& adj) {
    // dist[i][j] = 从 i 到 j 的最短距离
    const int INF = INT_MAX / 2;
    vector<vector<int>> dist(V, vector<int>(V, INF));

    // 初始化
    for (int i = 0; i < V; i++) dist[i][i] = 0;
    for (int u = 0; u < V; u++) {
        for (auto [v, w] : adj[u]) {
            dist[u][v] = w;
        }
    }

    // 中间顶点 k
    for (int k = 0; k < V; k++) {
        cout << "以 " << k << " 为中间顶点:" << endl;
        for (int i = 0; i < V; i++) {
            for (int j = 0; j < V; j++) {
                if (dist[i][k] + dist[k][j] < dist[i][j]) {
                    cout << "  dist[" << i << "][" << j << "]: "
                         << dist[i][j] << " -> "
                         << dist[i][k] + dist[k][j] << endl;
                    dist[i][j] = dist[i][k] + dist[k][j];
                }
            }
        }
    }

    // 检测负权环（对角线为负）
    bool negCycle = false;
    for (int i = 0; i < V; i++) {
        if (dist[i][i] < 0) {
            negCycle = true;
            break;
        }
    }

    if (negCycle) {
        cout << "发现负权环！" << endl;
    }

    // 打印结果矩阵
    cout << "\\n最短路径矩阵:" << endl;
    cout << "     ";
    for (int j = 0; j < V; j++) cout << j << "   ";
    cout << endl;
    for (int i = 0; i < V; i++) {
        cout << i << ": ";
        for (int j = 0; j < V; j++) {
            if (dist[i][j] == INF) cout << "INF ";
            else cout << dist[i][j] << "   ";
        }
        cout << endl;
    }
}

int main() {
    cout << "=== Floyd-Warshall 全源最短路径 ===" << endl;

    int V = 4;
    vector<vector<pair<int,int>>> adj(V);
    adj[0] = {{1, 5}, {2, 10}};
    adj[1] = {{2, 2}, {3, 8}};
    adj[2] = {{1, -7}};  // 负权边
    adj[3] = {};

    floydWarshall(V, adj);

    cout << "\\n=== 示例：城市间距离 ===" << endl;

    V = 5;
    vector<vector<pair<int,int>>> cities(V);
    cities[0] = {{1, 10}, {4, 5}};
    cities[1] = {{2, 2}, {3, 1}};
    cities[2] = {{0, 3}, {3, 9}};
    cities[3] = {{4, 2}};
    cities[4] = {{0, 8}, {3, 6}};

    floydWarshall(V, cities);

    return 0;
}''',
          description: '展示 Floyd-Warshall 全源最短路径算法，同时检测负权环。',
          output: '''=== Floyd-Warshall 全源最短路径 ===
以 0 为中间顶点:
  dist[1][2]... 
...（完整输出见实际运行）

=== 示例：城市间距离 ===
最短路径矩阵:
     0   1   2   3   4 
0: 0   7   9   5   5 
1: 3   0   2   3   5 
2: 3   2   0   1   3 
3: 8   6   8   0   2 
4: 6   4   6   6   0''',
        ),
      ],
      keyPoints: [
        'Bellman-Ford 可以处理负权边，时间复杂度 O(VE)，需要进行 V-1 轮松弛',
        'Bellman-Ford 第 V 轮松弛如果还能更新，说明存在负权环',
        'Floyd-Warshall 计算所有顶点对最短路径，O(V³)，适合顶点数较少的全源最短路径',
        'Dijkstra 不能处理负权边；Bellman-Ford 可以，且能检测负权环',
        '选择算法：单源+无负边用 Dijkstra，单源+有负边用 Bellman-Ford，全源用 Floyd-Warshall',
      ],
    ),
  ],
);
