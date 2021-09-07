'''
You are given an integer, N. Your task is to print an alphabet rangoli of size N . 
(Rangoli is a form of Indian folk art based on creation of patterns.)

Different sizes of alphabet rangoli are shown below:

#size 3

----c----
--c-b-c--
c-b-a-b-c
--c-b-c--
----c----

#size 5

--------e--------
------e-d-e------
----e-d-c-d-e----
--e-d-c-b-c-d-e--
e-d-c-b-a-b-c-d-e
--e-d-c-b-c-d-e--
----e-d-c-d-e----
------e-d-e------
--------e--------

#size 10

------------------j------------------
----------------j-i-j----------------
--------------j-i-h-i-j--------------
------------j-i-h-g-h-i-j------------
----------j-i-h-g-f-g-h-i-j----------
--------j-i-h-g-f-e-f-g-h-i-j--------
------j-i-h-g-f-e-d-e-f-g-h-i-j------
----j-i-h-g-f-e-d-c-d-e-f-g-h-i-j----
--j-i-h-g-f-e-d-c-b-c-d-e-f-g-h-i-j--
j-i-h-g-f-e-d-c-b-a-b-c-d-e-f-g-h-i-j
--j-i-h-g-f-e-d-c-b-c-d-e-f-g-h-i-j--
----j-i-h-g-f-e-d-c-d-e-f-g-h-i-j----
------j-i-h-g-f-e-d-e-f-g-h-i-j------
--------j-i-h-g-f-e-f-g-h-i-j--------
----------j-i-h-g-f-g-h-i-j----------
------------j-i-h-g-h-i-j------------
--------------j-i-h-i-j--------------
----------------j-i-j----------------
------------------j------------------

The center of the rangoli has the first alphabet letter a, and the boundary has the

alphabet letter (in alphabetical order).

Function Description

Complete the rangoli function in the editor below.

rangoli has the following parameters:

    - int size: the size of the rangoli

Returns

    - string: a single string made up of each of the lines of the rangoli separated by a newline character (\n)

Input Format

Only one line of input containing size, the size of the rangoli.

Constraints

0 < size < 27

Sample Input

5

Sample Output

--------e--------
------e-d-e------
----e-d-c-d-e----
--e-d-c-b-c-d-e--
e-d-c-b-a-b-c-d-e
--e-d-c-b-c-d-e--
----e-d-c-d-e----
------e-d-e------
--------e--------
'''


'''
okay its bit different compare to door mat problems i did
as far as i can see, it pick letter from a, so if size is 3
then abc, c is what will start it.
which would explain about the width of it, as line continue going down, we go to next letter till it hit a then going backward.

so that mean we need to find a pattern to estimate a width.
given from sample, we know input is 5
and max width is 17 
going from top to down
1,5,9,13,14
so with that, we can see differences is 4 each line...
does that mean it is 5 * 4? no its 20..
what if we do (5*4)-3 aka (size * 4) - 3
that would give 17 but does it work for others cases?
say size 3, that mean (3*4) - 3 = 9, let have a look at sample with size 3
answer is yes. it is indeed 9.... so now we got a size...
then what if we also do (n-1) * 4 + 1
so with size 5, that give 17, and with 3, that also 9 so yes this also work.
'''
import string

def print_rangoli(n):
    letters = string.ascii_lowercase[:n] 
    letters = tuple(reversed(letters))
    if len(letters) == 1: return print(''.join(letters))
    
    layout = []
    
    
    width = (n-1) * 4 + 1
    for i in range(n):
        line = '-'.join(letters[:i+1])
        flip = ''.join(reversed(line[:-2]))
        line += f'-{flip}'
        layout.append(line.center(width,'-'))
    
    layout.extend(list(reversed(layout[:-1])))
    print('\n'.join(layout))

if __name__ == '__main__':
    n = int(input())
    print_rangoli(n)
