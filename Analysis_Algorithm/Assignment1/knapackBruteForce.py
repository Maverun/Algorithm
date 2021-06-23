"""
Maverun
Assignment 1 Question 2 Knapsack
Feb 20 2021

2. (10 points) Write a program that uses the brute-force approach to solve the
0/1 knapsack problem. Suppose there are n items with weights w1, w2, ...,
wn and values v1, v2, ..., vn and a knapsack of capacity W.
Use the decrease-by-one technique to generate the power set and calculate the
total weights and values of each subset, then find the largest value that fits
into the knapsack and output that value.

For example: If there are 3 items with the following weights and values:
                  weight: 8 4 5
                  value:  20 10 11
and the capacity of the knapsack is 9, your program should then
calculate the total weight and the total value of each subset in the power set:

            total weight of subset: 0, 8, 4, 12, 5, 13, 9, 17
            total value of subset:  0, 20, 10, 30, 11, 31, 21, 41
The largest value that fits into the knapsack: 21.


Discussion:

Since we are given weight with value and we want to get best value while ensure
weight is under capacity.

If we are doing brute force, we can do one by one,
then remove any weight above capacity, then start compare values, get max one

raw_data <-- { n:[n_values, n_weight] }
subset <-- [] #2D array
max_capacity <-- x

#Getting number
function built():
    for i <-- 0 to raw_data.length do
        temp <-- [i]
        subset <-- append([i])
        for j <-- i+1 to raw_data.length do
            temp <-- append(j)
            if j != i+1 then subset <-- append(temp)
            subset <-- append([i,j])
    data = []

    for i <-- 0 to subset.length:
        data <-- append(subset[i],*calc(subset[i]))

function calc (data:array):
    weight <-- 0
    values <-- 0
    for i <--0 to data.length do
        values <-- values + raw_data[i][0]
        weight <-- weight + raw_data[i][1]
    return values,weight



With this, we are getting 2 of O(n^2)
"""

# total weight of subset: 0, 8, 4, 12, 5, 13, 9, 17
# total value of subset:  0, 20, 10, 30, 11, 31, 21, 41
# n:{values,weight}
raw_data = {
    1:[20,8],
    2:[10,4],
    3:[30,12],
    4:[11,5],
    5:[31,13],
    6:[21,9],
    7:[41,17]
}#end of raw_data


max_capacity = 9

def built():
    subset = []
    for i in range(1,len(raw_data)+1):
        temp = [i]
        subset.append([i])
        for j in range(i+1,len(raw_data)+1):
            temp = list(temp) #New pointer
            temp.append(j)
            if j != i+1: subset.append(temp) #avoid dupelication of [i,j]
            subset.append([i,j])
    subset = sorted(subset,key=len) #make it look nicer for print later
    #End of loops building, here we will calculate total values 
    data = []
    for ele in subset:
        result = [ele,*calc(ele)]
        data.append(result)
    #there is 2 of O(n^2) 
    return data

def calc(array):
    weight = 0
    values = 0
    for i in array:
        values += raw_data[i][0]
        weight += raw_data[i][1]
    return values,weight #returning in "array" format

data = built()
print()
answer = 0
for i,ele in enumerate(data):
    if ele[2] > max_capacity: continue
    if ele[1] >= data[answer][1]: answer = i
    #i put = cuz if later is match, better cuz more item compare to early on.

print("Since we have those item")
for key,value in raw_data.items():
    print(f"Item:{key} - Values:{value[0]} - Weight:{value[1]}")

print("\nNow we we will calculate to show result")
print("Index|Values|Weight|Subset")
for i,ele in enumerate(data,start=1):
    sub,val,wei = ele #Expand them to each 
    print(f"{i:3} - {val:4} - {wei:4} - {sub}")

print(f"As showing, the best is {answer + 1}")
