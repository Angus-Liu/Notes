### 题目：

> Given a string **S** and a string **T**, count the number of distinct subsequences of **T** in **S**. 
>
> A subsequence of a string is a new string which is formed from the original string by deleting some (can be none) of the characters without disturbing the relative positions of the remaining characters. (ie, `"ACE"` is a subsequence of `"ABCDE"` while `"AEC"` is not). 
>
> Here is an example:
>
> **S** = `"rabbbit"`, **T** = `"rabbit"`
>
> Return `3`.

给定两个字符串S和T，求S有多少个不同的子串与T相同。S的子串定义为在S中任意去掉0个或者多个字符形成的串。 

### 思路：

> When you see string problem that is about subsequence or matching, dynamic programming method should come to your mind naturally.  

动态规划，设`dp[i][j]` 是从字符串S[0...i]中删除几个字符得到字符串T[0...j]的不同的删除方法种类，动态规划方程如下

- 如果S[i] = T[j]， `dp[i][j] = dp[i-1][j-1]+dp[i-1][j]`

- 如果S[i] 不等于 T[j]， `dp[i][j] = dp[i-1][j]`

- 初始条件：当T为空字符串时，从任意的S删除几个字符得到T的方法为1

- `dp[0][0] = 1`; // T和S都是空串.

  `dp[1 ... S.length()][0] = 1;` // T是空串，S只有一种子序列匹配，即删掉所有字符。

  `dp[0][1 ... T.length()] = 0;` // S是空串，T不是空串，S没有子序列匹配。

### 代码：

```java
// 此题目未完成，几日后再补
public class Main {

    public static void main(String[] args) {
        String S = "rabbabit";
        String T = "rabbit";
//        T = "";
        int num = numOfSub(S, T);
        System.out.println(num);
    }

    public static int numOfSub(String S, String T) {
        int[][] table = new int[S.length() + 1][T.length() + 1];
        printTable(S, T, table);

        for (int i = 0; i <= S.length(); i++) {
            table[i][0] = 1; // 初始状况，T长度为0
            printTable(S, T, table);
        }

        for (int i = 1; i <= S.length(); i++) {
            for (int j = 1; j <= T.length(); j++) {
                if (S.charAt(i - 1) == T.charAt(j - 1)) {
                    table[i][j] = table[i - 1][j] + table[i - 1][j - 1];
                    printTable(S, T, table);
                } else {
                    table[i][j] = table[i - 1][j];
                    printTable(S, T, table);
                }
            }
        }

        return table[S.length()][T.length()];
    }

    // 辅助方法，用于打印table
    public static void printTable(String S, String T, int[][] table) {

        System.out.print("\t\t");
        for (int i = 0; i < T.length(); i++) {
            System.out.print(T.charAt(i) + "\t");
        }
        System.out.println();

        for (int i = 0; i < table.length; i++) {
            if (i == 0) {
                System.out.print("\t");
            }
            if (i > 0) {
                System.out.print(S.charAt(i - 1) + "\t");
            }
            for (int j = 0; j < table[0].length; j++) {
                System.out.print(table[i][j] + "\t");
            }
            System.out.println();
        }
        System.out.println("----------------------");
    }
}
```

### 参考：

+ [Distinct Subsequences leetcode java](http://www.cnblogs.com/springfor/p/3896152.html)

+ [LeetCode Distinct Subsequences 不同的子序列](http://www.cnblogs.com/grandyang/p/4294105.html)

