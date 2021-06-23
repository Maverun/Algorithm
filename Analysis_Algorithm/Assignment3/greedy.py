#==============================================================================#
#                                                                              #
#                        Fri 26 Mar 2021 10:27:30 PM EDT                       #
#                              Author: Maverun                                 #
#                                                                              #
#==============================================================================#


#==============================================================================#
#                                   Question                                   #
#==============================================================================#


# 2. (10 points) A contractor is given a list of n jobs. Each job takes exactly one hour to finish.
#Each job ji has a profit pi (pi  > 0) and a deadline di (1≤ di ≤ n).
#The profit is earned only if the job is completed by the deadline.
#Design and implement a greedy algorithm to create a job schedule that maximizes the profit.  
#A job schedule is a list of the selected jobs in the order they should be completed. 
#A job should not be selected if the contractor cannot complete it before the deadline.

#==============================================================================#
#                                   Example                                    #
#==============================================================================#

# For example, if the number of jobs is 4 and the profits and deadlines are as below:

# Job
	
# j1,j2,j3,j4

# profit
# 100,10,15,27

# deadline
# 2,1,2,1

# then the schedule should be j4  j1. The profit is 27 + 100 = 127.

# Another example: if the number of jobs is 5 and the profits and deadlines are as below:

# Job
	
# j1,j2,j3,j4,j5

# profit
# 5,15,10,20,1

# deadline
# 3,2, 1, 2, 3

# then the schedule should be j2  j4  j1. The profits are 15 + 20 + 5 = 40. 

# So here my idea
# Sort list based on deadline
# then loop each, find max profit within same deadline level then off to next repeat
#Since we know each job will take one hours no matter what.
#==============================================================================#
#                                   Algorithm                                  #
#==============================================================================#


# job <- [[profit,deadline,name]] #2D array
# job <- sort(job by job[0][0]) #sort by profits

# max_deadline <- max(job[0][1]) #find max deadline in job list
# order_job <- [1..max_deadline]
# current_hour <- 0

# for i <- 0 to length(jobs) do 
    # if length(order_job) = max_deadline then break 
    # if current_hours > jobs[i][1] then continue  #if we past deadline already.
    # order_job <- append(jobs[i])
    # current_hours <- current_hours + 1

# #Now we got a order of each job with max profit

# #==============================================================================#
# #                                    Coding                                    #
# #==============================================================================#
def print_job_list(j):
    print("|      The JOBS LIST      |")
    print("|-------------------------|")
    print("| Job | Profit | Deadline |") #5 to |, 8 to |, 10 to |
    print("|-------------------------|") #25 length
    for e in jobs:
        fmt = "|".ljust(2) + e[2].ljust(4) + "| " 
        fmt = fmt.ljust(2) + str(e[0]).ljust(7) + "| "
        fmt = fmt.ljust(2) + str(e[1]).ljust(9) + "| "
        print(fmt)
        print("|-------------------------|") 

#First we create job list we are given
raw_jobs = [
    [5,3,"J1"],
    [15,2,"J2"],
    [10,1,"J3"],
    [20,2,"J4"],
    [1,3,"J5"]
]

#Let sort it out based on deadline from low to high
#Sort it based on high to low profits
jobs = sorted(raw_jobs,key = lambda x:x[0], reverse=True)


#First we are getting max deadline we can get, so we can fill them up.
max_deadline = max(jobs,key = lambda x:x[1])[1]

order_job = []
current_hours = 0 #Starting at 0, cuz well... we are starting at 0 of course.

#now we will schedule them from high profit to low within deadline capacity
#Good things is that, each job only take 1 hours, so we dont have to concern
#about how much it take up.
for i,j in enumerate(jobs):
    if len(order_job) == max_deadline: break
    #We want to make sure we still can do this job within deadline.
    if current_hours > j[1]: continue
    #If still within capacity of deadline we can do
    #e.g deadline is 2, and we are starting at 0 hour
    #We still have 2 hours spare, so one of them will take up
    order_job.append(j)
    #Add current hours we are at 
    current_hours += 1


#==============================================================================#
#                                    Result                                    #
#==============================================================================#

print_job_list(raw_jobs)

print("So the best order to get maximum profits you could get is ")
for i,j in enumerate(order_job):
    # print(f"{jobs[i][2]} ({jobs[i][0]})",end='')
    print(f"{j[2]} ({j[0]})",end='')
    if i != len(order_job)-1: print(" > ", end ='')

print("\n")
total = sum(x[0] for x in order_job) #List comprehive
print(f"And total profit you will earn is {total}")
