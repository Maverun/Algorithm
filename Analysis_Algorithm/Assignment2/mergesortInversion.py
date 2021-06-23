"""
Maverun

Assignment 2 part 1
March 6, 2021
1. (10 points) Let a[0..n-1] be an array of n distinct integers.
A pair (a[i], a[j]) is said to be an inversion if these numbers are out of order
, i.e., i < j but a[i] > a[j].

For example: if array a contains the following numbers:
                     9, 8, 4, 5
then the number of inversions is 5.
(inversions are 9 > 8, 9 > 4, 9 > 5, 8 > 4, 8 > 5)

Write a program that uses the divide-and-conquer  technique to count the
number of inversions in an array.

This is original Algorithm from slide, with a bit tweak, of course,
this is huge different with my current algorithm but principle of it is same


Mergesort(A[0..n-1],counter)
    if n > 1
        copy A[0..[n/2]-1] to B[0..[n/2]-1]
        copy A[[n/2]..n-1] to C[0..[n/2]-1]
        counterB <-- Mergesort(B[0..[n/2]-1])
        counterC <-- Mergesort(C[0..[n/2]-1])
        counter = Merge(B,C,A,counter+counterB+counterC)
    return counter

Merge(B[0..p-1],C[0..q-1],A[0..p+q-1])
    i <- 0; j <- 0; k <- 0

    while i < p and j < q do
        if B[i] <= C[j]
            A[k] <-- B[i]; i <-- i + 1
        else
            A[k] <-- C[j]
            j <-- j + 1
            counter <-- counter + length(B)
        k <- k + 1

        if i = p
            copy C[j..q-1] to A[k..p+q -1]
        else copy B[i..p-1] to A[k..p+q-1]
    return counter
"""


def mergeSort(a,counter=0):
    n = len(a)
    if n > 1:
        mid = int(n/2)#Saving some process time...
        #Array slice works like this [START:END:STEP]
        l = a[:mid]
        r = a[mid:]
        l,counter_L = mergeSort(l)
        r,counter_R = mergeSort(r)
        a,counter = merge(l,r,counter_L + counter_R + counter)
    return a,counter

def merge(l,r,counter):
    # l = left half 
    # r = right half
    a = [] #empty array

    while(len(l) != 0 and len(r) != 0):
        if r[0] >= l[0]:
            a.append(l.pop(0))
        else:
            a.append(r.pop(0))
            #Since it is on RIGHT HALF, so meaning, any LEFT bigger than RIGHT.
            counter += len(l)
    #Any leftover, put it in.
    while(len(l)):
        a.append(l.pop(0))
    while(len(r)):
        a.append(r.pop(0))
    return a,counter


data = [9,8,4,5]
sa,counter = mergeSort(data)
print(f"With {data}, total inversion is {counter}")
