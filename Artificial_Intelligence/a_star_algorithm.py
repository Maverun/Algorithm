"""
Maverun
COSC3117 (AI)
Assignment 1

Main goal is to solve flat rubik 
Where color match in row
 ---
|RRR|
|GGG|
|BBB|
 ---
By using A* search algorithm.

Formula is
F = G + H

My Herustics is based on total wrong title / 3
3 is for how much tile have to move 
So that why it is wrong_tile_total/3 

"""
from colorama import init, Fore, Back, Style

init(autoreset=True)

class Direction:
        up = 0
        down = 1
        left = 2
        right = 3

#Setting up start and end goal by using color code
original_start = [["R","G","G"],
                 ["G","B","R"],
                 ["B","R","B"]]

start = [["R","G","G"],
        ["G","B","R"],
        ["B","R","B"]]

end =  [["R","R","R"],
        ["G","G","G"],
        ["B","B","B"]]



class State:
    def __init__(self,**kwargs):
        self.data = kwargs.get("data")
        self.parent = kwargs.get("parent")
        self.f = 0
        self.g = kwargs.get("g",0)
        self.h = kwargs.get("h",0)
        self.move = kwargs.get("move")
        self.pos = kwargs.get("pos")

    def __eq__(self,other):
        return self.data == other.data


def row_shift(data,direction,r):
        """
        direction: 2 or 3 for side way 
        """
        if direction not in (Direction.left, Direction.right): return
        side = [len(data)-1] if Direction.left == direction else [len(data)-1,0,-1]
        step = 1 if Direction.left == direction else -1
        for x in range(*side):
            hold = data[r][x]
            data[r][x] = data[r][x + step]
            data[r][x + step] = hold

def col_shift(data,direction,c):
        """
        direction: 0 or 1 for side way up or down 
        """
        if direction not in (Direction.up, Direction.down): return
        side = [len(data[0])-1] if Direction.up == direction else [len(data[0])-1,0,-1]
        step = 1 if Direction.up == direction else -1

        for x in range(*side):
            hold = data[x][c]
            data[x][c] = data[x + step][c]
            data[x + step][c] = hold

#first we will create move where we will check each movement.
move = [[row_shift,Direction.left],
        [row_shift,Direction.right],
        [col_shift,Direction.up],
        [col_shift,Direction.down]]

def wrong_tile(state):
    array = []
    for i in range(len(state.data)):
        for j in range(len(state.data)):
            #Remember, First row is Red, 2nd Row is Green, and Last row is Blue
            if state.data[i][j] != end[j][i]: array.append((i,j))
    return array #to say THERE IS NO WRONG TILE thus it is end goal?


def copy(data): return [row[:] for row in data] # this allow to make a copy of 2D array without pointer to original...

def calc_h(data,coord):
    total_wrong = 0
    for i in range(len(data)):
        for j in range(len(data[i])):
            if data[i][j] != end[i][j]: total_wrong += 1
    return total_wrong / 3

def start_program():
    start_node = State(data=copy(start))
    open_list = [start_node]
    close_list = []
    counter = 0
    while len(open_list) > 0:
        current_node = open_list[0]
        current_index = 0
        counter += 1
        print(current_node.data,"F:",current_node.f,"Counter Loops:",counter)
        
        for index,item in enumerate(open_list): #start with lowest one
            if item.f < current_node.f: 
                current_node = item
                current_index = index
        
        #now we are updating List.
        open_list.pop(current_index) #we need to remove from open list to avoid dupe
        close_list.append(current_node) #and we need to add current node to list since we are using this one.
        if current_node.data == end: return current_node #we found the path and solve it!
        
        children = [] 
        w_tile_array = wrong_tile(current_node)
        if w_tile_array is None: return current_node #???? we will check this later

        for w_tile in w_tile_array:
            for mv in move: #we are checking all move we can do, such as row shift left/right or column shift up/down
                new_data = copy(current_node.data) #Copy the data.
                new_h = calc_h(new_data,w_tile) #getting H?
                pos_move = w_tile[0] if mv[0] == row_shift else w_tile[1]
                #since inside move contain like this [ [func_ptr,direction]]
                mv[0](new_data,mv[1],pos_move)
                

                #G always have to be 1 as a cost to move but we are also adding prev G from curr node
                new_node = State(data = new_data,parent = current_node,
                        g=1+current_node.g,h=new_h,
                        move=mv,pos=pos_move) 
                new_node.f = new_node.g + new_node.h # F = G + H

                children.append(new_node)
        
        for child in children:
            #now we are checking each children before we decide to add it to open list such as already in visit list etc
            if sum(1 for visited_child in close_list if visited_child == child) > 0: continue # we are skipping if it already in close list!
            
            #now we are checking if child is ALREADY in the list, if so, we need to compare G cost, we want lower cost
            if sum(1 for i in open_list if child == i and child.g >= i.g) > 0: continue
           
            open_list.append(child)


def direction(x):
    if x == Direction.up: return "up"
    elif x == Direction.down: return "down"
    elif x == Direction.left: return "left"
    elif x == Direction.right: return "right"

def print_path(p):
    #Credits to Gareth on codegolf
    ordinal = lambda n: "%d%s" % (n,"tsnrhtdd"[(n//10%10!=1)*(n%10<4)*n%10::4])
    print()#new line
    if p.move is not None:
        print(f"{ordinal(p.pos+1)} {p.move[0].__name__.replace('_',' ')} {direction(p.move[1])} ")
    for index, ele in enumerate(p.data):
        for x in ele:
            if x=="R": color =Style.BRIGHT + Fore.RED + "R"
            elif x == "G": color = Style.BRIGHT + Fore.GREEN + "G"
            else: color = Style.BRIGHT + Fore.BLUE + "B"
            print(color,end="")
        print() #new line


path = start_program()

if path: print("Done! No problem with it!")    
else: print("Couldn't find solution!")

if path:
    curr = path
    arr = [curr]
    while curr.data != original_start:
        arr.insert(0,curr.parent)
        curr = curr.parent

    for p in arr:
        print_path(p)

    print("Total path is ", len(arr)-1) #-1 cuz first one is starter path.

