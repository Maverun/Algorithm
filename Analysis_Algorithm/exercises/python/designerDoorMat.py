"""
Mr. Vincent works in a door mat manufacturing company. One day, he designed a new door mat with the following specifications:

- Mat size must be NxM.(N is an odd natural number,and M is 3 times N.)
- The design should have 'WELCOME' written in the center.
- The design pattern should only use |, . and - characters.

Sample Designs

Size: 7 x 21 
    ---------.|.---------
    ------.|..|..|.------
    ---.|..|..|..|..|.---
    -------WELCOME-------
    ---.|..|..|..|..|.---
    ------.|..|..|.------
    ---------.|.---------
    
Size: 11 x 33
    ---------------.|.---------------
    ------------.|..|..|.------------
    ---------.|..|..|..|..|.---------
    ------.|..|..|..|..|..|..|.------
    ---.|..|..|..|..|..|..|..|..|.---
    -------------WELCOME-------------
    ---.|..|..|..|..|..|..|..|..|.---
    ------.|..|..|..|..|..|..|.------
    ---------.|..|..|..|..|.---------
    ------------.|..|..|.------------
    ---------------.|.---------------

Input Format

A single line containing the space separated values of N and M.

Constraints

- 5 < N < 101
- 15 < M < 303

Output Format
    Output the design pattern.

Sample Input
    9 27

Sample Output

------------.|.------------
---------.|..|..|.---------
------.|..|..|..|..|.------
---.|..|..|..|..|..|..|.---
----------WELCOME----------
---.|..|..|..|..|..|..|.---
------.|..|..|..|..|.------
---------.|..|..|.---------
------------.|.------------
"""

'''
Okay so, this is very interesting problem
here what we know, n is height and m is width
so with first example, 7 x 27
so those pattern, as far as i can observe
first line contain 3 char
2nd contain 9 char
3: 15
4: 21
5th: WELCOME
6: 21
7: 15
8: 9
9: 3

so that mean, 3,9,15,21,WELCOME,21,15,9,3
next pattern i notice is that its always ".|."
each line add more to previously on both side
'''

n,m = map(int,input().split()) 
pattern = '.|.'

half = round(n/2 + 0.5)
pattern_holder = 1
pattern_adder = 2
for i in range(1,n+1):
    # first we will check if it half there or you know
    if i == half:
        print("WELCOME".center(m,'-'))
        pattern_adder = pattern_adder * -1 #making it negative side, since we going backward
    else:
        print(f'{pattern * pattern_holder}'.center(m,'-'))
    pattern_holder += pattern_adder

#That was a fun challenge.
