#==============================================================================#
#                                                                              #
#                       Sun 21 Mar 2021 10:42:42 PM EDT                        #
#                             Author: Maverun                                  #
#                                                                              #
#==============================================================================#




# 1. (10 points) Write a program to implement the Horspool’s algorithm.
# Your program should ask the user to enter a text and a pattern,
# then output the following: 
# (a) shift table
# (b) the searching result (whether the pattern is in the text or not)


# So we should first create a shift table

# If I am not mistake, the way it work is that

# it create a list of alphabet order

# then we use pattern to see how differences it is
# using last char in pattern (string) as a starter

# such as BAOBAB 

# so with BAOBAB
# if we need find closest A to last char
# and that is 1
# and we need to find closest B (btw last char are not include)
# so that is 2
# and 0 is 3 away,
# that it, we are only looking for unique char that is closest to last

# so final result is
# A - 1
# B - 2
# O - 3
# Remain alphabet are length of pattern, so 6

# so let create table then
# FYI String is Char array.
# ShiftTable(P:String)
# table -> hashmap

# for i <- length(P) to 0 do
#     if P[i] in table then continue
#     table[P[i]] <- length(p) - i
# return table

# now when we search text with pattern

# HorspoolMatching(P:String,Table[0..n-1],Text:String)
#     x <- length(P) - 1
#     i <- x
#     while i <= n do 
#         k <- 0
#         while k <= x and P[x-k] == Text[i-k] do
#            # k <- k + 1
#         if k = x then return i - x + 1
#         else i <-- i + Table[T[i]]
#   return -1

def shift_table(pattern):
    """
    Function: shift table

    Params:
    pattern: String 
    """
    table = {}
    for i,t in enumerate(reversed(pattern[:-1]),start=1): #ignore last element
        if t in table: continue
        table[t] = i
    return table
#end of the function shift table

def horspool(table,pattern,text):
    """
    Function: horspool

    Params:
    table: Hashmap of Shift Table
    pattern: Pattern we will use to look for in text
    text: String
    """
    #not -1 cuz is string, so doesn't start at 0
    length = len(pattern)
    max_length = len(text)
    i = length
    #Now we check till we reach end of text
    while i <= max_length:
        k = 0
        print(text)
        print(pattern.rjust(i))
        print("-"*max_length)
        #if we found match, then keep count till it is not longer match or out of length
        while k <= length and pattern[length - 1 - k] == text[i - k]:
            k += 1
        if k == length: 
            print(text)
            print(pattern.rjust(i+1))
            return i - length + 1 
        else: i += table.get(text[i],length) #if none in shift, then full length
    return -1
    
#end of the function horspool

def print_table(table):
    print("|Printing Shift Table|")
    print("|--------------------|")#20 space
    for key,values in table.items():
        x = key.rjust(5)
        x += "|".rjust(5)
        temp = str(values)
        temp = temp.ljust(5)
        x = x.ljust(20 - len(temp))
        x += temp
        print(f"|{x}|")
        print("|--------------------|")#20 space


raw_text = input("Enter your text: ") 
raw_pattern = input("Enter the pattern: ")
raw_table = shift_table(raw_pattern)

print_table(raw_table)
result = horspool(raw_table,raw_pattern,raw_text)


if result != -1:
    print("we found the pattern, it is at ",result+1, " to ", result + len(raw_pattern))
else:
    print("There wasn't any pattern in this text!")






