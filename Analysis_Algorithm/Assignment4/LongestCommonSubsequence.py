#==============================================================================#
#                       Fri 09 Apr 2021 05:07:47 PM EDT                        #
#                             Author: Maverun                                  #
#==============================================================================#


#==============================================================================#
#                                                                              #
#                  1. (10 points) Write a program to solve the                 #
#                      Longest Common Subsequence problem                      #
#              using dynamic programming as discussed in class.                #
#               For example, if the input is X = ABCBDAB and Y =               #
#                                    BDCABA,                                   #
#               then the output of your program should be BCBA.                #
#==============================================================================#

# So as far as I can understand this question asking, I need to find a way to find 
# common substring between two string 



# So let try think of few ideas to do this
# First, we dont want to do brute force way cuz of time complexity


# Algorithm:

# lcd <- []

# x <- First String 
# y <- Second String

# while len(x) = 0 or len(y) = 0:
    # s <- x.pop()
    # i <- y.index(s)
    # if i > 0
        # lcd <- append(s)
        # y.pop(i)

# print "LCD is " + len(lcd) + "and substring is " + lcd 

#Above failed since it doesnt meet requirment of the question

# def solution(x,y, lx, ly)
    # if lx or yx reach end then return empty string 
    # if x[lx] == y[ly] then
        # return x[lx] + solution(x,y,lx+1,ly+1)

    # l = solution(x,y,lx+1,ly) 
    # r = solution(x,y,lx,ly+1)
    # if len(l) > len(r) then return l
    # return r



x = input("Enter First String:") 
y = input("Enter Second String:")

def solution(x,y,lx = 0 ,ly = 0): 
    """
    Function: second solution
    Params:
        x: First String 
        y: Second String
        lx: current y index
        ly: current y index 
    """

    if lx == len(x) or ly == len(y) : return ""
    if x[lx] == y[ly]:
        return x[lx] + solution(x,y,lx+1,ly+1) 
    l = solution(x,y,lx+1,ly) 
    r = solution(x,y,lx,ly+1)
    if len(l) > len(r): return l
    return r
    
#end of the function second solution
d = solution(x,y)
print(f"LCD is {''.join(d)}")

