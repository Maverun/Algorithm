"""
Maverun
Assignment 1 Q2 Count Substring
FEB 20,2021

1. (10 points) Given a string of characters,
count the number of substrings that start with an A and end with a B.
For example, there are four such substrings in CABAAXBYA,
i.e. AB, ABAAXB, AAXB, AXB. Write a program that uses the brute-force approach
to count the number of such substrings in a given string.

A sample dialogue might look like as follows:

Please enter a string: ADABCBA

The number of substrings that start with an A and end with a B is 4


Solutions:
Ask users for input String
Ask users for input of start and end with

Check if start and end is in String input, (if start in input and end in input)
If confirm they are in

Proceed to loops O(n^2) systems
Where first loops move to find any "start" char then
run second loops to count total end

Algorithm:
Input: input, start, end : String
Output: counter - INT

input <-- input
start <-- input char
end <-- input char
counter <-- 0

if start not in input AND end not in input: Return 0

for i <-- 0 to input.length do
    if input[i] = start
        for j <-- i+1 to input.length do
            if input[j] == end
                counter <-- counter + 1
"""

def count(string,start,end):
    counter = 0

    for i in range(len(string)):#Start loops
        if string[i] == start: #If we found what start with, then 2nd loops
            for j in range(i,len(string)): #Since we are finding end and counter+1
                if string[j] == end: counter += 1
    return counter


string = input("Enter input: ")
start = input("Enter start: ")
end = input("Enter end: ")

if len(start) == 0 or len(end) == 0:
    print("You didn't enter any input for start/end!")
    exit(1)
result = count(string,start[0],end[0]) #doing [0] in case user enter more than one...
print(f"With {start[0]} and {end[0]}, it found {result} so far")
