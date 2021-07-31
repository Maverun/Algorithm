"""

There is a horizontal row of
cubes. The length of each cube is given. You need to create a new vertical pile of cubes. The new pile should follow these directions: if cube[i] is on top of cube[j] then
sideLength[j] >= sideLength[i].

When stacking the cubes, you can only pick up either the leftmost or the rightmost cube each time. Print Yes if it is possible to stack the cubes. Otherwise, print No.

Example
blocks = [1,2,3,8,7]
Result: No

After choosing the rightmost element,
, choose the leftmost element, . After than, the choices are and . These are both larger than the top block of size

.

blocks = [1,2,3,8,7]
Result: Yes

Choose blocks from right to left in order to successfully stack the blocks.

Input Format

The first line contains a single integer T, the number of test cases.
For each test case, there are 2 lines.
The first line of each test case contains n, the number of cubes.
The second line contains n space separated integers, denoting the sideLengths of each cube in that order.

Constraints
1 <= T <= 5
1 <= n <= 10^5
1 <= sideLength < 2^31


Output Format

For each test case, output a single line containing either Yes or No.

Sample Input

STDIN        Function
-----        --------
2            T = 2
6            blocks[] size n = 6
4 3 2 1 3 4  blocks = [4, 3, 2, 1, 3, 4]
3            blocks[] size n = 3
1 3 2        blocks = [1, 3, 2]

Sample Output

Yes
No

Explanation

In the first test case, pick in this order: left -4, right - 4 , left - 3 , right - 3 , left - 2 , right - 1 .
In the second test case, no order gives an appropriate arrangement of vertical cubes. 3 will always come after either 1 or 2.
"""
d = []

#getting data and put them into block under d
for i in range(int(input())):
    n = int(input())
    b = [int(x) for x in input().split()]
    d.append(b)

for block in d:
    current  = 2 ** 1026 #setting it max as floor is infinite.
    while len(block):
        #if leftmost is less than current block and is greater than rightmost, then we will use this
        if block[0] <= current and block[0] >= block[-1]: current = block.pop(0)
        #viceversa
        elif block[-1] <= current and block[-1] >= block[0]: current = block.pop()
        else: break
    if len(block): print("No")
    else: print("Yes")
