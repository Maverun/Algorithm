#Maverun
from colorama import Fore,Back,Style,init
import random
# import pygame
import math

init(autoreset=True) #just in case someone use window and just auto reset it!

maze_map = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 4, 0, 1],
            [2, 0, 0, 0, 0, 4, 0, 0, 1, 1, 1, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1],
            [1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1],
            [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1],
            [1, 4, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 3],
            [1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 4, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]

       #East,West,North,South
gene = ["00","01","10","11"]

limit_gnome = 50 #how many bits are limited. 50 bit is enough, 40 is lowest i seen.
population = 100


# pygame.init()
# screen = pygame.display.set_mode((500,500))
# screen_

class Person:
    def __init__(self,**kwargs):
        self.position = kwargs.get("position")
        self.fitness = None
        self.chromesome = kwargs.get("chromesome",self.create_gnome())
        self.is_end = False
        self.is_block = False

    def mutated_genes(self):#since we will mutate by randomly flip or so...
        return random.choice(gene)

    def create_gnome(self):
        return "".join([self.mutated_genes() for x in range(limit_gnome)]) #convert to str

    def walk(self):
        self.position = None
        pos = list(starter_pos) #make a new object of this array, so no pointer to old.
        for i in range(0,limit_gnome,2):
            ch = self.chromesome[i:i+2] #shortcut cuz lazy yo
            if ch   == "00": pos[1] += 1
            elif ch == "01": pos[1] -= 1
            elif ch == "10": pos[0] -= 1
            elif ch == "11": pos[0] += 1
            self.position = pos
            if pos[0] < 0 or pos[0] >= len(maze_map) or pos[1] < 0 or  pos[1] >= len(maze_map[0]):
                    self.is_block = True
                    break #it is out of map so we leaving!
            spot = maze_map[pos[0]][pos[1]]
            if spot in (1,4):
                self.is_block = True
                return #return instead of break so we can say it NONE
            elif spot == 3:
                self.is_end = True #We finally reached end!
                print("FOUND IT HORAY!")

    def mate(self,partner):
        child_chromesome  = ""
        for i in range(0,limit_gnome,2):
            ch1 =  self.chromesome[i:i+2]
            ch2 =  partner.chromesome[i:i+2]

            prob = random.random() #making random yo
            if prob < 0.40: child_chromesome += ch1
            elif prob < 0.9: child_chromesome += ch2 
            else: child_chromesome += self.mutated_genes()
        return Person(chromesome = child_chromesome)

    def calc_fitness(self):
        end = find_end_goal() if end_goal_positon == None else end_goal_positon
        #we will use that famous so called Pythagorean Thoeorem
        #cuz we are moving in 4 direction, up/down or left/right, so that mean X and Y
        #if we are moving in 8 (North-East, North-West etc), we could do Eulican one instead
        # if self.is_block:
            # self.fitness = 999 #making it saying it is block/dead
            # return self.fitness
        if self.is_end:
            self.fitness = 0
            return
        x = pow(end[0] - self.position[0],2)
        y = pow(end[1] - self.position[1],2)
        self.fitness = math.sqrt(x+y)
        return self.fitness

    def birth(self):
        data = {"position":self.position,"total_movement":self.total_movement}
        return Person(**data)

#end class Person
def find_starter_position():
    for i in range(len(maze_map)):
        for j in range(len(maze_map[i])):
            if maze_map[i][j] == 2: return [i,j]

def find_end_goal():
    for i in range(len(maze_map)):
        for j in range(len(maze_map[i])):
            if maze_map[i][j] == 3: return [i,j]
#end of find_end_goal


end_goal_positon = find_end_goal()
starter_pos = find_starter_position()
def start():
    found = False
    generation = 0
    people = []
    elite = int((10*population)/100) #we are getting 10% fittest to next gen
    off_spring_pop = int((90*population)/100)
    for _ in range(population):
        per = Person()
        per.chromesome = per.create_gnome()
        per.walk()
        per.calc_fitness()
        people.append(per)
    while not found:
        generation += 1
        people = sorted(people,key = lambda x:x.fitness)
        # print([x.fitness for x in people])
        if people[0].is_end: return [generation,people[0]]

        new_people = [] #we are setting new people for next generation replace of people
        new_people.extend(people[:elite])
        #from there 50% will offspring, having kids ya know.
        for x in range(population - len(new_people)): #remain to offspring!
            parent = random.choice(people[:30])
            parent1 = random.choice(people[:30])
            child = parent.mate(parent1) #papa and mama met and start giving birth.
            child.walk() #dont have time to wait for kids grow! Just skip to walk!
            child.calc_fitness() #Need to know so we can filter out useless and excellent
            new_people.append(child)
        #put it in people, so we can use this for next generation!
        people = new_people
        print(f"Generation: {generation}, Fitness:{people[0].fitness}, END:{people[0].is_end},POS:{people[0].position}")



def convert_bit(data):
    direction = []
    for x in range(0,len(data),2):
        d = data[x:x+2]
        if d == "00": direction.append("East")
        elif d == "01": direction.append("West")
        elif d == "10": direction.append("North")
        elif d == "11": direction.append("South")

    print(direction)

def show_map(data):
    maze = maze_map
    pos = starter_pos
    bit_total = None
    for x in range(0,len(data),2):
        d = data[x:x+2]
        if d == "00":  pos[1] += 1 
        elif d == "01":pos[1] -= 1
        elif d == "10":pos[0] -= 1
        elif d == "11":pos[0] += 1
        if maze_map[pos[0]][pos[1]] == 3:
            print("Contain first ", x, "bits")
            bit_total = bit_total
            break
        if maze_map[pos[0]][pos[1]] in (1,4): 
            print("BLOCK")
            break
        maze_map[pos[0]][pos[1]] = 9

        for i in maze_map:
            for j in i:
                if j == 9:
                    print(Fore.GREEN + "9",end ="")
                else:
                    print(j,end="")
            print()
        print('\r'*len(maze_map))
    return data[:bit_total]

gen,person = start()
bit_total = show_map(person.chromesome)
print(bit_total)
convert_bit(bit_total)

print(f"This took {gen} generation!")
