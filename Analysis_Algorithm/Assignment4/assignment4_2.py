#==============================================================================#
#                                                                              #
#                       Sat 10 Apr 2021 12:41:00 AM EDT                        #
#                             Author: Maverun                                  #
#==============================================================================#


#==============================================================================#
#                                                                              #
#               2. (10 points) Suppose you need to create a work               #
#                plan, and each week you have to choose a job to               #
#                undertake. The set of possible jobs is divided                #
#                     into low-stress and high-stress jobs.                    #
#                                                                              #
#              If you select a low-stress job in week i, then you              #
#                 get a revenue of li dollars; if you select a                 #
#               high-stress job, you get a revenue of hi dollars.              #
#                The catch, however, is that in order for you to               #
#              take on a high-stress job in week i, it’s required              #
#                that you rest in week i − 1 because you need a                #
#              full week of prep time to get ready for the stress              #
#                level (It’s okay to choose a high-stress job in               #
#                  week 1.) On the other hand, you can take a                  #
#               low-stress job in week i even if you have done a               #
#                       job (of either type) in week i−1.                      #
#                                                                              #
#              Given a sequence of n weeks, a plan is speciﬁed by              #
#               a choice of “low-stress”, “high-stress” or “none”              #
#               for each of the n weeks, with the constraint that              #
#                if “high-stress” is chosen for week i > 1, then               #
#              “none” must be chosen for week i − 1. The value of              #
#                the plan is determined in the natural way; for                #
#                 each i, you add li to the value if you choose                #
#                 “low-stress” in week i, and you add hi to the                #
#               value if you choose “high-stress” in week i. (You              #
#                    add 0 if you choose “none” in week i.)                    #
#                                                                              #
#               Example: Suppose n=4, and the values of li and hi              #
#              are given by the following table. Then the plan of              #
#                the maximum value would be to choose “none” in                #
#                   week 1, a high stress job in week 2, and                   #
#                low-stress jobs in weeks 3 and 4. The value of                #
#                       this plan would be 0+50+10+10=70.                      #
#==============================================================================#

# i Week 1 Week 2 Week 3 Week 4
# l 10 1 10 10 
# h 5 50 5 1

# Far as I can see that we can do go backward finding best
# if High happen to be best then we will one more back to see which have more values
# then decide there

#==============================================================================#
#                                   Algorithm                                  #
#==============================================================================#

# l <- low stress value 
# h <- high stress value
# week <- total weeks
# profits = 0

# for i = week - 1 to 0 do 
    # if h[i] > l[i] then 
        # if h[i-1] > h[i] then #ignore this and do low instead 
            # profit <- profit + l[i]
        # else then
            # profit <- profit + h[i]
            # i <- i - 1#ignore prev week of this week
    # else then 
        # profit <- profit + l[i]

def print_job(l,h):
    """
    Function: print job
    """
    week = len(h)
    week = [f"| Week {x} " for x in range(1,week + 1)]
    week = "|  i   " + "".join(week) + "|"
    line = len(week) * "-"
    print(line)
    print(week)
    print(line)
    low =  [f"|  {x:3}   " for x in l]
    low = "|  l   " + "".join(low) + "|"
    high =  [f"|  {x:3}   " for x in h]
    high = "|  h   " + "".join(high) + "|"
    print(low)
    print(line)
    print(high)
    print(line)
#end of the function print job




l = [10,1,10,10]
h = [5,50,5,1]
week = len(h)
profits = 0
order = ""

wasHigh = False

for i in range(week-1,-1,-1):
    if wasHigh: 
        wasHigh = False 
        order = f"Week {i+1}: None\n" + order 
    elif h[i] > l[i]:
        if h[i-1] > h[i]:
            profits += l[i]
            order = f"Week {i+1}: Low\n" + order
        else:
            profits += h[i]
            order = f"Week {i+1}: High\n" + order
            wasHigh = True
    else:
        profits += l[i]
        order = f"Week {i+1}: Low\n" + order

print_job(l,h)
print("Total Profits is ",profits)
print("Order of job is")
print(order)

