![](assets/图片1.png)

这样感觉更好一点

![](assets/Avatar.jpg)

这样感觉更好一点

```java
public class Test {
    /**
     * 输入一个矩阵，按照从外向里以顺时针的顺序依次打印每一个数字
     *
     * @param numbers 输入的二维数组，二维数组必须是N*M的，否则分出错
     */
    public static void printMatrixClockWisely(int[][] numbers) {
        // 输入的参数不能为空
        if (numbers == null) {
            return;
        }

        // 记录一圈（环）的开始位置的行
        int x = 0;
        // 记录一圈（环）的开始位置的列
        int y = 0;
        // 对每一圈（环）进行处理，
        // 行号最大是(numbers.length-1)/2
        // 列号最大是(numbers[0].length-1)/2
        while (x * 2 < numbers.length && y * 2 < numbers[0].length) {
            printMatrixInCircle(numbers, x, y);
            // 指向下一个要处理的的环的第一个位置
            x++;
            y++;
        }
    }

    public static void printMatrixInCircle(int[][] numbers, int x, int y) {
        // 数组的行数
        int rows = numbers.length;
        // 数组的列数
        int cols = numbers[0].length;

        // 输出环的上面一行，包括最中的那个数字
        for (int i = y; i <= cols - y - 1; i++) {
            System.out.print(numbers[x][i] + " ");
        }

        // 环的高度至少为2才会输出右边的一列
        // rows-x-1：表示的是环最下的那一行的行号
        if (rows - x - 1 > x) {
            // 因为右边那一列的最上面那一个已经被输出了，所以行呈从x+1开始，
            // 输出包括右边那列的最下面那个
            for (int i = x + 1; i <= rows - x - 1; i++) {
                System.out.print(numbers[i][cols - y - 1] + " ");
            }
        }

        // 环的高度至少是2并且环的宽度至少是2才会输出下面那一行
        // cols-1-y：表示的是环最右那一列的列号
        if (rows - x - 1 > x && cols - 1 - y > y) {
            // 因为环的左下角的位置已经输出了，所以列号从cols-y-2开始
            for (int i = cols - y - 2; i >= y; i--) {
                System.out.print(numbers[rows - 1 - x][i] + " ");
            }
        }

        // 环的宽度至少是2并且环的高度至少是3才会输出最左边那一列
        // rows-x-1：表示的是环最下的那一行的行号
        if (cols - 1 - y > y && rows - 1 - x > x + 1) {
            // 因为最左边那一列的第一个和最后一个已经被输出了
            for (int i = rows - 1 - x - 1; i >= x + 1; i--) {
                System.out.print(numbers[i][y] + " ");
            }
        }
    }
}
```







# Android校招面试指南

## [![img](assets/page_icon.jpg)](https://github.com/Guangxs/android_interview/blob/master/assets/page_icon.jpg)

## Java

- [Java基础](https://github.com/Guangxs/android_interview/blob/master/java/basis.md)
- [Java并发](https://github.com/Guangxs/android_interview/blob/master/java/concurrence.md)
- [Java虚拟机](https://github.com/Guangxs/android_interview/blob/master/java/virtual-machine.md)

## Android

- [Android基础](https://github.com/Guangxs/android_interview/blob/master/android/basis.md)
- [Android进阶](https://github.com/Guangxs/android_interview/blob/master/android/advance.md)
- [开源框架](https://github.com/Guangxs/android_interview/blob/master/android/open-source-framework.md)

## 数据结构

- [线性表](https://github.com/Guangxs/android_interview/blob/master/data-structure/linear-list.md)
- [栈和队](https://github.com/Guangxs/android_interview/blob/master/data-structure/stack-queue.md)
- [树](https://github.com/Guangxs/android_interview/blob/master/data-structure/tree.md)
- [图](https://github.com/Guangxs/android_interview/blob/master/data-structure/graph.md)
- [散列查找](https://github.com/Guangxs/android_interview/blob/master/data-structure/hash.md)
- [排序](https://github.com/Guangxs/android_interview/blob/master/data-structure/sort.md)
- [海量数据处理](https://github.com/Guangxs/android_interview/blob/master/data-structure/mass_data_processing.md)

## 算法

- [剑指offer](https://github.com/Guangxs/android_interview/blob/master/algorithm/For-offer.md)
- [LeetCode](https://github.com/Guangxs/android_interview/blob/master/algorithm/leetcode.md)

## 设计模式

- [创建型模式](https://github.com/Guangxs/android_interview/blob/master/design-mode/Builder-Pattern.md)
- [结构型模式](https://github.com/Guangxs/android_interview/blob/master/design-mode/Structural-Patterns.md)
- [行为型模式](https://github.com/Guangxs/android_interview/blob/master/design-mode/Behavioral-Pattern.md)

## 计算机网络

- [TCP/IP](https://github.com/Guangxs/android_interview/blob/master/computer-networks/tcpip.md)
- [HTTP](https://github.com/Guangxs/android_interview/blob/master/computer-networks/http.md)
- [HTTPS](https://github.com/Guangxs/android_interview/blob/master/computer-networks/https.md)

## 操作系统

- [概述](https://github.com/Guangxs/android_interview/blob/master/operating-system/summarize.md)
- [进程与线程](https://github.com/Guangxs/android_interview/blob/master/operating-system/process-thread.md)
- [内存管理](https://github.com/Guangxs/android_interview/blob/master/operating-system/memory-management.md)

## 数据库

- [SQL语句](https://github.com/Guangxs/android_interview/blob/master/sql/SQL.md)

## 致谢

| 贡献者       | 贡献内容        | 贡献者    | 贡献内容                   |
| ------------ | --------------- | --------- | -------------------------- |
| YiKun        | Java集合        | Zane      | AbstractQueuedSynchronizer |
| DERRANTCM    | 剑指offer       | 占小狼    | ConcurrentHashMap          |
| skywang12345 | 数据结构        | IAM四十二 | Android动画总结            |
| Carson_Ho    | Android基础     | me115     | 图解设计模式               |
| Piasy        | Android开源框架 | 朱祁林    | https原理解析              |
| stormzhang   | Android全局异常 | Trinea    | Parcelable和Serializable   |

| 贡献者     | 贡献内容            | 贡献者     | 贡献内容                      |
| ---------- | ------------------- | ---------- | ----------------------------- |
| AriaLyy    | 多线程断点续传      | JackieYeah | Java深拷贝和浅拷贝            |
| ZHANG_L    | Android进程优先级   | 尹star     | Android Context详解           |
| HELLO丶GUY | Fragment详解        | Shawon     | Android推送技术               |
| 徐凯强Andy | 动态规划            | aaronice   | LeetCode/LintCode题解         |
| 码农一枚   | BlockingQueue       | Alexia     | Java transien和finally return |
| 朔野       | Android Apk安装过程 | 黑泥卡     | Dialog和PopupWindow           |

持续更新，仍有更多内容尚未完善，欢迎大家投稿。