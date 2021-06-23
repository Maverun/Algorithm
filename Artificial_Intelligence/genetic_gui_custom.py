"""
Maverun
COSC3117
Dec 9,2020
Assignment 3

This is Genetic Algorithm that can do standard maze
or custom maze in GUI forms.
"""
from colorama import Fore,Back,Style,init
import pygame.freetype
import random
import pygame
import math

import time
init(autoreset=True) #just in case someone use window and just auto reset it!

answer = input("Do you want Standard Maze(1) or Custom Maze(2):")

pygame.init()
screen = pygame.display.set_mode((1000,1000))

#Setting
class Setting:
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


    limit_gnome = 50 #how many bits are limited. 50 bit is enough, 40 is lowest i seen.
    population = 100
    delay = 0.5
    end_goal_position = None
    starter_pos  = None

############# End Setting
#East,West,North,South
gene = ["00","01","10","11"]
screen.fill((0,0,0))
game_font = pygame.freetype.SysFont("Arial",24)

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
        return "".join([self.mutated_genes() for x in range(Setting.limit_gnome)]) #convert to str

    def walk(self):
        self.position = None
        pos = list(Setting.starter_pos) #make a new object of this array, so no pointer to old.
        for i in range(0,Setting.limit_gnome,2):
            ch = self.chromesome[i:i+2] #shortcut cuz lazy yo
            if ch   == "00": pos[1] += 1
            elif ch == "01": pos[1] -= 1
            elif ch == "10": pos[0] -= 1
            elif ch == "11": pos[0] += 1
            self.position = pos
            if pos[0] < 0 or pos[0] >= len(Setting.maze_map) or pos[1] < 0 or  pos[1] >= len(Setting.maze_map[0]):
                    self.is_block = True
                    break #it is out of map so we leaving!
            spot = Setting.maze_map[pos[0]][pos[1]]
            if spot in (1,4):
                self.is_block = True
                return #return instead of break so we can say it NONE
            elif spot == 3:
                self.is_end = True #We finally reached end!
                print("FOUND IT HORAY!")

    def mate(self,partner):
        child_chromesome  = ""
        for i in range(0,Setting.limit_gnome,2):
            ch1 =  self.chromesome[i:i+2]
            ch2 =  partner.chromesome[i:i+2]

            prob = random.random() #making random yo
            if prob < 0.40: child_chromesome += ch1
            elif prob < 0.9: child_chromesome += ch2
            else: child_chromesome += self.mutated_genes()
        return Person(chromesome = child_chromesome)

    def calc_fitness(self):
        end = find_end_goal() if Setting.end_goal_position == None else Setting.end_goal_position
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
    for i in range(len(Setting.maze_map)):
        for j in range(len(Setting.maze_map[i])):
            if Setting.maze_map[i][j] == 2: return [i,j]

def find_end_goal():
    for i in range(len(Setting.maze_map)):
        for j in range(len(Setting.maze_map[i])):
            if Setting.maze_map[i][j] == 3: return [i,j]
#end of find_end_goal

def draw_maze(draw_obj = Setting.maze_map,fill=True):
    size = screen.get_size()
    if fill: screen.fill((255,255,255))
    #Draw grid first!
    for i in range(0,size[0],50):
        for j in range(100,size[1],50):
            pygame.draw.line(screen,color=(0,0,0),start_pos = (0,j),end_pos = (size[0],j))
        pygame.draw.line(screen,color=(0,0,0),start_pos = (i,100),end_pos = (i,size[1]))

    draw_object(draw_obj)
    pygame.display.flip()

def color_code(spot):
    #space = 0 = white
    #wall = 1 = black
    #starter = 2 = yellow
    #goal = 3 = green  
    #enemy = 4 = red
    #step = 9 = blue
    if spot == 0: return None
    elif spot == 1: return (0,0,0)
    elif spot == 2: return (255,255,0)
    elif spot == 3: return (0,255,0)
    elif spot == 4: return (255,0,0)
    elif spot == 9: return (0,0,255)

def draw_object(maze = Setting.maze_map):
    #Now we will put object inside!
    #Black is wall
    #Red is enemy
    #Green is goal
    #Yellow is starter
    size = screen.get_size()
    row = col = 0
    for x in range(0,size[0],50):
        if row == len(maze[col]): break # this x loops
        for y in range(0,size[1],50):
            if col == len(maze): break #this y loops
            rect = pygame.Rect(x,y+100,50,50)
            #print(rect,row,col, Setting.maze_map[col][row])
            #we flip with col and row, so that it show on right rotate.
            color = color_code(maze[col][row])
            if color:
                pygame.draw.rect(screen,color = color_code(maze[col][row]),rect = rect)
            col += 1
        row += 1
        col = 0

def draw_generation(people,gen):
    draw_maze(Setting.maze_map)
    text_surface,rect = game_font.render(f"Generations:{gen}",(255,0,0))
    text_surface1,rect1 = game_font.render(f"Delay:{Setting.delay}",(255,0,0))
    text_surface2,rect2 = game_font.render(f"Up/Down Key = +-0.1ms",(255,0,0))
    screen.blit(text_surface,(0,0))
    screen.blit(text_surface1,(0,25))
    screen.blit(text_surface2,(0,50))

    for p in people:
        #trick behind this is that row is Y and col is X for drawing.
        row,col = p.position
        rect = pygame.Rect(col*50,row*50+100,50,50)
        pygame.draw.rect(screen,color =(255,0,255),rect = rect)
    pygame.display.flip()


def custom_maze():
    maze_map = [[0 for y in range(20)] for x in range(18)] #we are setting up default array.
    text_s,rect   = game_font.render("0 for start",(0,0,0))
    text_s1,rect1 = game_font.render("1 for space",(0,0,0))
    text_s2,rect2 = game_font.render("2 for wall",(0,0,0))
    text_s3,rect3 = game_font.render("3 for enemy",(0,0,0))
    text_s4,rect4 = game_font.render("4 for starter (one only)",(0,0,0))
    text_s5,rect5 = game_font.render("5 for goal (one only)",(0,0,0))

    Setting.limit_gnome = 100 #Since we dont know if user will do whole range or small so.. This is prob a best bet?
    clock = pygame.time.Clock()
    mode = None
    star_pos = []
    end_pos = []
    draw_maze(maze_map)
    fill = False
    while True: #waiting for user press 0 to start.
        draw_maze(maze_map,fill=fill)
        screen.blit(text_s,(0,0))
        screen.blit(text_s1,(0,25))
        screen.blit(text_s2,(0,50))
        screen.blit(text_s3,(0,75))
        screen.blit(text_s4,(150,0))
        screen.blit(text_s5,(150,25))
        pygame.display.flip()
        fill = False
        for event in pygame.event.get():
            if event.type == pygame.KEYUP:
                if event.key == pygame.K_0:
                    Setting.maze_map =  maze_map
                    return
                elif event.key == pygame.K_1: mode = 0 #empty
                elif event.key == pygame.K_2: mode = 1 #wall
                elif event.key == pygame.K_3: mode = 4 #enemy
                elif event.key == pygame.K_4: mode = 2 #starter
                elif event.key == pygame.K_5: mode = 3 #goal

            if pygame.mouse.get_pressed()[0] and mode is not None:
                x,y = pygame.mouse.get_pos()
                if y < 100: continue #ignore it cuz we want only in grid area.
                row,col = int((y-100)/50),int(x/50) #Y is for Row and X is for Column which make sense when look at 2D array structure
                maze_map[row][col] = mode
                fill = True
                if mode == 2: #we need to confirm there no dupe.
                    if len(star_pos) > 0: maze_map[star_pos[0]][star_pos[1]] = 0
                    star_pos = [row,col]
                if mode == 3: #we need to confirm there no dupe.
                    if len(end_pos) > 0: maze_map[end_pos[0]][end_pos[1]] = 0
                    end_pos =[row,col]
        clock.tick(60)
    #end While True
    Setting.maze_map = maze_map

def start():
    found = False
    generation = 0
    people = []
    elite = int((10*Setting.population)/100) #we are getting 10% fittest to next gen
    off_spring_pop = int((90*Setting.population)/100) #Remain of 90% ^
    Setting.end_goal_position = find_end_goal()
    Setting.starter_pos = find_starter_position()
    if Setting.starter_pos is None or Setting.end_goal_position is None:
        print("You do not have starter/end point!")
        exit(0)
    for _ in range(Setting.population): #First generation start.
        per = Person()
        per.chromesome = per.create_gnome()
        per.walk()
        per.calc_fitness()
        people.append(per)
    while not found:
        #Pygame input for delay 
        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_UP: Setting.delay += 0.1
                elif event.key == pygame.K_DOWN: Setting.delay -= 0.1
                if Setting.delay <= 0.1: Setting.delay = 0 #so we can avoid neg.

        generation += 1
        people = sorted(people,key = lambda x:x.fitness)
        if people[0].is_end: return [generation,people[0]]

        new_people = [] #we are setting new people for next generation replace of people
        new_people.extend(people[:elite])
        #from there 50% will offspring, having kids ya know.
        for x in range(off_spring_pop): #remain to offspring!
            parent = random.choice(people[:30])
            parent1 = random.choice(people[:30])
            child = parent.mate(parent1) #papa and mama met and start giving birth.
            child.walk() #dont have time to wait for kids grow! Just skip to walk!
            child.calc_fitness() #Need to know so we can filter out useless and excellent
            new_people.append(child)
        
        #put it in people, so we can use this for next generation!
        people = new_people
        print(f"Generation: {generation}, Fitness:{people[0].fitness}, END:{people[0].is_end},POS:{people[0].position}")
        draw_generation(people,generation) #Drawing map of each people in generation at last spot.
        time.sleep(Setting.delay)

def convert_bit(data): #Convert bit to direction so it is human-readable
    direction = []
    for x in range(0,len(data),2):
        d = data[x:x+2]
        if d == "00": direction.append("East")
        elif d == "01": direction.append("West")
        elif d == "10": direction.append("North")
        elif d == "11": direction.append("South")

    print(direction)

def show_map(data): #we are printing out map on CMD
    maze = Setting.maze_map
    pos = Setting.starter_pos
    bit_total = None
    for x in range(0,len(data),2):
        d = data[x:x+2]
        if d == "00":  pos[1] += 1 
        elif d == "01":pos[1] -= 1
        elif d == "10":pos[0] -= 1
        elif d == "11":pos[0] += 1
        if Setting.maze_map[pos[0]][pos[1]] == 3:
            print("Contain first ", x, "bits")
            bit_total = bit_total
            break
        if Setting.maze_map[pos[0]][pos[1]] in (1,4): 
            print("BLOCK")
            break
        Setting.maze_map[pos[0]][pos[1]] = 9

        for i in Setting.maze_map:
            for j in i:
                if j == 9:
                    print(Fore.GREEN + "9",end ="")
                else:
                    print(j,end="")
            print()
        print('\r'*len(Setting.maze_map))
    return data[:bit_total]


if answer == "2": custom_maze()
gen,person = start()
bit_total = show_map(person.chromesome)
print(bit_total)
convert_bit(bit_total)
draw_maze(Setting.maze_map)

text_surface,rect = game_font.render(f"Generations:{gen}",(255,0,0))
screen.blit(text_surface,(0,0))
pygame.display.flip()

print(f"This took {gen} generation!")
input("Press any key to end.")
