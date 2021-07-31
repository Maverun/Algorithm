"""
A newly opened multinational brand has decided to base their company logo on the three most common characters in the company name. They are now trying out various combinations of company names and logos based on this condition. Given a string

, which is the company name in lowercase letters, your task is to find the top three most common characters in the string.

    Print the three most common characters along with their occurrence count.
    Sort in descending order of occurrence count.
    If the occurrence count is the same, sort the characters in alphabetical order.

For example, according to the conditions described above,

GOOGLE would have it's logo with the letters G,O,E

.

Input Format

A single line of input containing the string S.

Constraints
- 3 < len(S) <= 10^4
- S has at least 3 distinct characters

Output Format

Print the three most common characters along with their occurrence count each on a separate line.
Sort output in descending order of occurrence count.
If the occurrence count is the same, sort the characters in alphabetical order.

Sample Input 0

aabbbccde

Sample Output 0

b 3
a 2
c 2

Explanation 0
aabbbccde
Here, b occurs 3 times. It is printed first.
Both a and c occur 2 times. So, a is printed in the second line and c in the third line because a comes before c in the alphabet.

Note: The string S has at least 3 distinct characters. 
"""

#my attempt this work but not for those that have same number value and are not sorted by letters...
"""
from collections import OrderedDict
d = OrderedDict()

for s in input():
    d[s] = d.get(s,0) + 1
top = sorted(d,key=lambda x:d[x],reverse=True)
for i in range(3):
    print(top[i],d[top[i]])
"""

#this notes was found from online
from collections import Counter

#this counter will count of each occurrence letters, and sort by letter
chars = Counter(input()).items()

#so that (-c[1]) is number columns in reverse, then c[0] is letter only that if it same value as other.
for char, n in sorted(chars, key=lambda c: (-c[1], c[0]))[:3]:
    print(char, n)

#so based on this, I realized could do sorted(d,key=lambda x:(-d[x],x)), and my attempt did work
#top = sorted(d,key=lambda x:(-d[x],x))
