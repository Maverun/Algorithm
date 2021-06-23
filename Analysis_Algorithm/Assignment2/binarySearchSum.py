"""
Maverun
Assignment 2
March 6,2021

2. (10 points) Given two lists of n integers A, B and a sum S,
where all the elements in each list are unique,
write a program that uses a transform-and-conquer algorithm with efficiency
class Θ(nlogn) to decide whether there is an integer from A and an integer from
B such that the sum of these two integers is equal to S.

For example, if A = {8, 3, 4, 7} and B = {5, 6, 12, 1} and
S is 10, then your program should output “4 + 6 = 10”
(where 4 is from A and 6 is from B).

Another example, if A = {1, 5, 4, 2} and B = {6, 3, 2, 1} and S is 9,
then your program should output “No two integers from A and B add up to 9”.


A <- A[0..n-1]
B <- B[0..n-1]
S <- INPUT

sort(A)
sort(B)

C <- [0..n-1] #2D array to contain answer?

for i <- 0 to n do
    for j <- to n do
        if A[i] + B[i] = S then C <-- append([i,j])
        elif A[i] + B[i] > S then break #Break out, pointless from there, no need to go on


"""

def binary_find(answer,a,arr):
    """
    Function: binary find

    Params:
    answer: Answer solution to look for
    arr: Array
    a: First Addition
    
    """
    mi = int(len(arr)/2)
    if arr[mi] + a == answer: return arr[mi]
    elif len(arr) -1 == mi: return -1 #If it not answer, then return
    elif arr[mi + 1] + a > answer: return binary_find(answer,a,arr[:mi]) 
    elif arr[mi - 1] + a < answer: return binary_find(answer,a,arr[mi:])
#end of the function binary find

data_A = [8,3,4,7]
data_B = [5,6,12,1]

asum = 10

solution = []

data_A = sorted(data_A) #Those use Timsort, which is worst case is O(nlogn)
data_B = sorted(data_B) #Best case is O(n), avg case is O(n logn)


for x in data_A:
    y = binary_find(asum,x,data_B)
    if y != -1 : solution.append([x,y])

#Loops of x with data_A end here
print(f"With {data_A} and {data_B}")
if len(solution):
    for x in solution:
        print(f"There is solution with {x[0]} + {x[1]} = {asum }")
    #Loops of x with soltion end here
else:
    print("There is no solution for this!")
