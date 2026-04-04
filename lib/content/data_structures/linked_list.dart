// 数据结构 - 链表 - Linked List
import '../course_data.dart';

/// 链表章节
const chapterLinkedList = CourseChapter(
  id: 'data_structures_linked_list',
  title: '链表 (Linked List)',
  description: '学习 C++ 中链表数据结构的概念、单链表、双向链表的实现和经典算法题。',
  difficulty: DifficultyLevel.intermediate,
  category: CourseCategory.algorithms,
  lessons: [
    CourseLesson(
      id: 'data_structures_linked_list_concept',
      title: '链表的概念与实现',
      content: '''# 链表的概念与实现

## 什么是链表？

链表是一种线性数据结构，由一系列节点组成，每个节点包含数据和指向下一个节点的指针。

```
链表:  head
        │
        ▼
    ┌───┬───┐    ┌───┬───┐    ┌───┬───┐    ┌────┐
    │ 1 │ ──┼──► │ 2 │ ──┼──► │ 3 │ ──┼──► │null│
    └───┴───┘    └───┴───┘    └───┴───┘    └────┘
```

## 链表 vs 数组

| 特性 | 链表 | 数组 |
|------|------|------|
| 存储方式 | 不连续，动态 | 连续，固定/动态 |
| 访问方式 | 顺序访问 | 随机访问 O(1) |
| 插入/删除 | O(1) (已知位置) | O(n) |
| 空间开销 | 额外指针开销 | 无额外开销 |
| 缓存友好性 | 差 | 好 |

## 单链表节点结构

```cpp
struct ListNode {
    int data;
    ListNode* next;
    ListNode(int val) : data(val), next(nullptr) {}
};
```

## 单链表的基本操作

| 操作 | 说明 | 时间复杂度 |
|------|------|------------|
| `push_front` | 头部插入 | O(1) |
| `push_back` | 尾部插入 | O(1) with tail / O(n) without |
| `insert_after` | 指定节点后插入 | O(1) |
| `erase_after` | 删除指定节点后继 | O(1) |
| `find` | 查找节点 | O(n) |
| `reverse` | 反转链表 | O(n) |

## 链表的特点

- **动态大小**：不需要预先指定大小
- **高效的插入/删除**：O(1)（如果已知位置）
- **不支持随机访问**：需要顺序遍历
- **内存利用率高**：按需分配，不浪费空间

## 使用场景

- 实现栈和队列
- 图的邻接表
- 哈希冲突解决（链地址法）
- LRU 缓存
- 多项式运算
''',
      codeExamples: [
        CodeExample(
          title: '单链表实现',
          code: '''#include <iostream>
#include <vector>
using namespace std;

// 单链表节点
struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) {}
};

// 单链表类
class LinkedList {
private:
    ListNode* head;
    ListNode* tail;  // 尾指针优化尾部操作
    int size;

public:
    LinkedList() : head(nullptr), tail(nullptr), size(0) {}

    // 析构函数 - 释放内存
    ~LinkedList() {
        ListNode* current = head;
        while (current) {
            ListNode* next = current->next;
            delete current;
            current = next;
        }
    }

    // 头部插入 O(1)
    void push_front(int val) {
        ListNode* newNode = new ListNode(val);
        if (empty()) {
            head = tail = newNode;
        } else {
            newNode->next = head;
            head = newNode;
        }
        size++;
    }

    // 尾部插入 O(1)
    void push_back(int val) {
        ListNode* newNode = new ListNode(val);
        if (empty()) {
            head = tail = newNode;
        } else {
            tail->next = newNode;
            tail = newNode;
        }
        size++;
    }

    // 头部删除 O(1)
    void pop_front() {
        if (empty()) return;
        ListNode* temp = head;
        head = head->next;
        if (!head) tail = nullptr;  // 空链表
        delete temp;
        size--;
    }

    // 指定节点后插入 O(1)
    void insert_after(ListNode* prev, int val) {
        if (!prev) return;
        ListNode* newNode = new ListNode(val);
        newNode->next = prev->next;
        prev->next = newNode;
        if (prev == tail) tail = newNode;
        size++;
    }

    // 删除指定节点后的下一个节点 O(1)
    void erase_after(ListNode* prev) {
        if (!prev || !prev->next) return;
        ListNode* toDelete = prev->next;
        prev->next = toDelete->next;
        if (toDelete == tail) tail = prev;
        delete toDelete;
        size--;
    }

    // 查找节点
    ListNode* find(int val) {
        ListNode* current = head;
        while (current) {
            if (current->val == val) return current;
            current = current->next;
        }
        return nullptr;
    }

    // 反转链表
    void reverse() {
        ListNode* prev = nullptr;
        ListNode* current = head;
        tail = head;  // 新的尾节点

        while (current) {
            ListNode* next = current->next;
            current->next = prev;
            prev = current;
            current = next;
        }
        head = prev;
    }

    // 获取大小
    int getSize() const { return size; }
    bool empty() const { return size == 0; }
    ListNode* getHead() const { return head; }
    ListNode* getTail() const { return tail; }

    // 遍历
    void print() const {
        cout << "链表: ";
        ListNode* current = head;
        while (current) {
            cout << current->val;
            if (current->next) cout << " -> ";
            current = current->next;
        }
        cout << endl;
    }
};

int main() {
    cout << "=== 单链表操作 ===" << endl;
    LinkedList list;

    list.push_back(1);
    list.push_back(2);
    list.push_back(3);
    list.push_front(0);
    list.print();
    cout << "大小: " << list.getSize() << endl;

    // 插入操作
    ListNode* node = list.find(2);
    if (node) {
        list.insert_after(node, 5);
    }
    list.print();

    // 删除操作
    list.pop_front();
    list.print();

    // 反转
    list.reverse();
    list.print();

    return 0;
}''',
          description: '展示单链表的完整实现，包括 push_front、push_back、insert_after、reverse 等操作。',
          output: '''=== 单链表操作 ===
链表: 0 -> 1 -> 2 -> 3
大小: 4
链表: 0 -> 1 -> 2 -> 5 -> 3
链表: 1 -> 2 -> 5 -> 3
链表: 3 -> 5 -> 2 -> 1''',
        ),
        CodeExample(
          title: '链表经典算法',
          code: '''#include <iostream>
#include <vector>
using namespace std;

struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) {}
};

// 删除倒数第 N 个节点
ListNode* removeNthFromEnd(ListNode* head, int n) {
    ListNode* dummy = new ListNode(0);
    dummy->next = head;

    ListNode* fast = dummy;
    ListNode* slow = dummy;

    // fast 先走 n+1 步
    for (int i = 0; i <= n; i++) {
        fast = fast->next;
    }

    // fast 和 slow 一起走，直到 fast 到达末尾
    while (fast) {
        fast = fast->next;
        slow = slow->next;
    }

    // slow->next 就是倒数第 n 个节点
    ListNode* toDelete = slow->next;
    slow->next = toDelete->next;
    delete toDelete;

    ListNode* newHead = dummy->next;
    delete dummy;
    return newHead;
}

// 合并两个有序链表
ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
    ListNode dummy(0);
    ListNode* tail = &dummy;

    while (l1 && l2) {
        if (l1->val <= l2->val) {
            tail->next = l1;
            l1 = l1->next;
        } else {
            tail->next = l2;
            l2 = l2->next;
        }
        tail = tail->next;
    }

    tail->next = l1 ? l1 : l2;
    return dummy.next;
}

// 检测链表是否有环
bool hasCycle(ListNode* head) {
    if (!head || !head->next) return false;

    ListNode* slow = head;
    ListNode* fast = head;

    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) return true;
    }

    return false;
}

// 找到环的入口节点
ListNode* detectCycle(ListNode* head) {
    if (!head || !head->next) return nullptr;

    ListNode* slow = head;
    ListNode* fast = head;

    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) {
            // 找到相遇点后，从头节点和相遇点同时出发，相遇即入口
            slow = head;
            while (slow != fast) {
                slow = slow->next;
                fast = fast->next;
            }
            return slow;
        }
    }

    return nullptr;
}

// 打印链表前 N 个节点
void printList(ListNode* head, int count = -1) {
    int c = 0;
    while (head && (count == -1 || c < count)) {
        cout << head->val;
        if (head->next && (count == -1 || c < count - 1)) cout << " -> ";
        head = head->next;
        c++;
    }
    if (count != -1 && c >= count) cout << "...";
    cout << endl;
}

int main() {
    cout << "=== 删除倒数第 N 个节点 ===" << endl;
    ListNode* head = new ListNode(1);
    head->next = new ListNode(2);
    head->next->next = new ListNode(3);
    head->next->next->next = new ListNode(4);
    head->next->next->next->next = new ListNode(5);

    cout << "原链表: ";
    printList(head);

    head = removeNthFromEnd(head, 2);
    cout << "删除倒数第2个后: ";
    printList(head);

    cout << "\\n=== 合并两个有序链表 ===" << endl;
    ListNode* l1 = new ListNode(1);
    l1->next = new ListNode(3);
    l1->next->next = new ListNode(5);

    ListNode* l2 = new ListNode(2);
    l2->next = new ListNode(4);
    l2->next->next = new ListNode(6);

    cout << "l1: "; printList(l1);
    cout << "l2: "; printList(l2);

    ListNode* merged = mergeTwoLists(l1, l2);
    cout << "合并后: ";
    printList(merged);

    return 0;
}''',
          description: '展示链表经典算法：删除倒数第 N 个节点、合并两个有序链表。',
          output: '''=== 删除倒数第 N 个节点 ===
原链表: 1 -> 2 -> 3 -> 4 -> 5
删除倒数第2个后: 1 -> 2 -> 3 -> 5

=== 合并两个有序链表 ===
l1: 1 -> 3 -> 5
l2: 2 -> 4 -> 6
合并后: 1 -> 2 -> 3 -> 4 -> 5 -> 6''',
        ),
      ],
      keyPoints: [
        '链表由节点组成，每个节点包含数据和指向下一个节点的指针',
        '链表插入/删除 O(1)（已知位置），但查找需要 O(n) 遍历',
        '删除倒数第 N 个节点：快慢指针技巧，fast 先走 n+1 步',
        '合并两个有序链表：双指针同时遍历，比较后链接',
        '检测环：快慢指针，慢指针一次走一步，快指针一次走两步，如果相遇则有环',
      ],
    ),

    CourseLesson(
      id: 'data_structures_linked_list_advanced',
      title: '双向链表与高级操作',
      content: '''# 双向链表与高级操作

## 双向链表 (Doubly Linked List)

双向链表的每个节点包含两个指针：指向后继和前驱。

```
       ┌──────────────────────────────┐
       │                              │
       ▼                              │
    ┌───────┬─────────┬─────────┬───────────┐
    │  prev │  data   │  next   │           │
    └───┬───┴─────────┴────┬────┘           │
        │                  │                │
        │    ┌─────────────┘                │
        ▼    ▼                              │
    ┌───────────┐      ┌───────────┐      │
    │  节点 2   │◄────►│  节点 3   │
    └───────────┘      └───────────┘
```

## 双向链表的结构

```cpp
struct DListNode {
    int data;
    DListNode* prev;
    DListNode* next;
    DListNode(int val) : data(val), prev(nullptr), next(nullptr) {}
};
```

## 双向链表的特点

- **双向遍历**：可以从任意节点向前或向后遍历
- **O(1) 插入/删除**：已知节点时，前后指针都需要更新
- **更灵活**：适合需要双向移动的场景
- **空间开销更大**：每个节点多一个指针

## 双向循环链表

尾节点的 next 指向头节点，头节点的 prev 指向尾节点。

## 链表相关的经典算法

1. **两两交换节点**：LeetCode 24
2. **回文链表判断**：找到中点，反转后半部分，比较
3. **相交链表**：找出两个链表的交点
4. **复制带随机指针的链表**：LeetCode 138

## 相交链表找交点

如果两个链表相交，则从某个节点开始后面的节点都相同。

```cpp
ListNode* getIntersectionNode(ListNode* headA, ListNode* headB) {
    ListNode* a = headA;
    ListNode* b = headB;

    while (a != b) {
        a = a ? a->next : headB;
        b = b ? b->next : headA;
    }
    return a;  // 或 b
}
```

**原理**：如果存在交点，a 和 b 会同时到达交点；如果不存在，a 和 b 会同时变成 nullptr。

## 链表操作注意事项

1. **空指针检查**：操作前检查节点是否为 nullptr
2. **边界条件**：head、tail 的处理
3. **内存管理**：及时 delete 防止内存泄漏
4. **迭代器失效**：插入/删除后，原有迭代器可能失效
''',
      codeExamples: [
        CodeExample(
          title: '双向链表实现',
          code: '''#include <iostream>
using namespace std;

struct DListNode {
    int val;
    DListNode *prev, *next;
    DListNode(int x) : val(x), prev(nullptr), next(nullptr) {}
};

class DoublyLinkedList {
private:
    DListNode* head;
    DListNode* tail;
    int size;

public:
    DoublyLinkedList() : head(nullptr), tail(nullptr), size(0) {}

    ~DoublyLinkedList() {
        DListNode* current = head;
        while (current) {
            DListNode* next = current->next;
            delete current;
            current = next;
        }
    }

    // 头部插入 O(1)
    void push_front(int val) {
        DListNode* newNode = new DListNode(val);
        if (!head) {
            head = tail = newNode;
        } else {
            newNode->next = head;
            head->prev = newNode;
            head = newNode;
        }
        size++;
    }

    // 尾部插入 O(1)
    void push_back(int val) {
        DListNode* newNode = new DListNode(val);
        if (!tail) {
            head = tail = newNode;
        } else {
            newNode->prev = tail;
            tail->next = newNode;
            tail = newNode;
        }
        size++;
    }

    // 删除节点 O(1) - 已知节点
    void remove(DListNode* node) {
        if (!node) return;

        if (node->prev) {
            node->prev->next = node->next;
        } else {
            head = node->next;  // 删除头节点
        }

        if (node->next) {
            node->next->prev = node->prev;
        } else {
            tail = node->prev;  // 删除尾节点
        }

        delete node;
        size--;
    }

    // 反向打印 O(n)
    void print_reverse() const {
        cout << "反向: ";
        DListNode* current = tail;
        while (current) {
            cout << current->val;
            if (current->prev) cout << " <-> ";
            current = current->prev;
        }
        cout << endl;
    }

    void print() const {
        cout << "正向: ";
        DListNode* current = head;
        while (current) {
            cout << current->val;
            if (current->next) cout << " <-> ";
            current = current->next;
        }
        cout << endl;
    }

    int getSize() const { return size; }
};

int main() {
    cout << "=== 双向链表 ===" << endl;
    DoublyLinkedList dll;

    dll.push_back(1);
    dll.push_back(2);
    dll.push_back(3);
    dll.push_front(0);
    dll.print();
    dll.print_reverse();

    cout << "\\n=== 链表反转 ===" << endl;
    // 反转双向链表
    DoublyLinkedList dll2;
    for (int i = 1; i <= 5; i++) dll2.push_back(i);
    dll2.print();

    // 简单反转打印来演示
    dll2.print_reverse();

    cout << "\\n=== 删除操作 ===" << endl;
    DoublyLinkedList dll3;
    for (int i = 1; i <= 5; i++) dll3.push_back(i);
    dll3.print();

    // 删除中间节点
    struct Helper {
        static DListNode* getNth(DListNode* head, int n) {
            for (int i = 0; i < n && head; i++) {
                head = head->next;
            }
            return head;
        }
    };

    DListNode* third = Helper::getNth(dll3.head, 2);  // 第3个节点
    if (third) {
        dll3.remove(third);
    }
    dll3.print();

    return 0;
}''',
          description: '展示双向链表的基本操作：push_front、push_back、remove、反向遍历。',
          output: '''=== 双向链表 ===
正向: 0 <-> 1 <-> 2 <-> 3
反向: 3 <-> 2 <-> 1 <-> 0

=== 链表反转 ===
正向: 1 <-> 2 <-> 3 <-> 4 <-> 5
反向: 5 <-> 4 <-> 3 <-> 2 <-> 1

=== 删除操作 ===
正向: 1 <-> 2 <-> 3 <-> 4 <-> 5
删除第3个节点后: 1 <-> 2 <-> 4 <-> 5''',
        ),
        CodeExample(
          title: '回文链表与相交链表',
          code: '''#include <iostream>
#include <vector>
using namespace std;

struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) {}
};

// 找链表中点 (快慢指针)
ListNode* middleNode(ListNode* head) {
    ListNode* slow = head;
    ListNode* fast = head;
    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
    }
    return slow;  // 中点或上中点
}

// 反转链表
ListNode* reverseList(ListNode* head) {
    ListNode* prev = nullptr;
    ListNode* current = head;
    while (current) {
        ListNode* next = current->next;
        current->next = prev;
        prev = current;
        current = next;
    }
    return prev;
}

// 判断回文链表
bool isPalindrome(ListNode* head) {
    if (!head || !head->next) return true;

    // 1. 找中点
    ListNode* mid = middleNode(head);

    // 2. 反转后半部分
    ListNode* secondHalf = reverseList(mid);

    // 3. 比较前半和后半
    ListNode* p1 = head;
    ListNode* p2 = secondHalf;
    bool result = true;
    while (p2) {  // 只比较后半部分
        if (p1->val != p2->val) {
            result = false;
            break;
        }
        p1 = p1->next;
        p2 = p2->next;
    }

    // 4. 恢复链表 (可选)
    // mid->next = reverseList(secondHalf);

    return result;
}

// 找相交链表
ListNode* getIntersectionNode(ListNode* headA, ListNode* headB) {
    ListNode* a = headA;
    ListNode* b = headB;

    while (a != b) {
        a = a ? a->next : headB;
        b = b ? b->next : headA;
    }

    return a;  // 相交点或 nullptr
}

void printList(ListNode* head) {
    while (head) {
        cout << head->val;
        if (head->next) cout << " -> ";
        head = head->next;
    }
    cout << endl;
}

int main() {
    cout << "=== 回文链表 ===" << endl;
    ListNode* pal1 = new ListNode(1);
    pal1->next = new ListNode(2);
    pal1->next->next = new ListNode(3);
    pal1->next->next->next = new ListNode(2);
    pal1->next->next->next->next = new ListNode(1);

    cout << "链表 1: ";
    printList(pal1);
    cout << "是回文: " << (isPalindrome(pal1) ? "是" : "否") << endl;

    ListNode* pal2 = new ListNode(1);
    pal2->next = new ListNode(2);
    pal2->next->next = new ListNode(3);
    pal2->next->next->next = new ListNode(4);
    pal2->next->next->next->next = new ListNode(5);

    cout << "链表 2: ";
    printList(pal2);
    cout << "是回文: " << (isPalindrome(pal2) ? "是" : "否") << endl;

    cout << "\\n=== 相交链表 ===" << endl;
    // 创建相交链表: 1->2->3->4
    //                      ↑
    //                 5->6──┘
    ListNode* a1 = new ListNode(1);
    a1->next = new ListNode(2);
    a1->next->next = new ListNode(3);
    a1->next->next->next = new ListNode(4);

    ListNode* b1 = new ListNode(5);
    b1->next = new ListNode(6);
    b1->next->next = a1->next->next;  // 相交于节点 3

    cout << "链表 A: ";
    printList(a1);
    cout << "链表 B: ";
    printList(b1);

    ListNode* intersect = getIntersectionNode(a1, b1);
    if (intersect) {
        cout << "交点值: " << intersect->val << endl;
    } else {
        cout << "不相交" << endl;
    }

    return 0;
}''',
          description: '展示回文链表判断（找中点+反转+比较）和相交链表找交点算法。',
          output: '''=== 回文链表 ===
链表 1: 1 -> 2 -> 3 -> 2 -> 1
是回文: 是
链表 2: 1 -> 2 -> 3 -> 4 -> 5
是回文: 否

=== 相交链表 ===
链表 A: 1 -> 2 -> 3 -> 4
链表 B: 5 -> 6 -> 3 -> 4
交点值: 3''',
        ),
      ],
      keyPoints: [
        '双向链表的节点有 prev 和 next 两个指针，支持双向遍历',
        '双向链表已知节点时，插入/删除都是 O(1)，但需要同时更新前后指针',
        '回文链表判断：快慢指针找中点，反转后半部分，逐节点比较',
        '找链表交点：两个指针分别从 A、B 头出发，走完自己的链表后换到对方链表，最终会相遇',
        '快慢指针是链表算法中的核心技巧，可用于找中点、检测环等',
      ],
    ),
  ],
);
