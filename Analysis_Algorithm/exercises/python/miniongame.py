"""
Kevin and Stuart want to play the 'The Minion Game'.

Game Rules

Both players are given the same string, S.
Both players have to make substrings using the letters of the string S.


Stuart has to make words starting with consonants.
Kevin has to make words starting with vowels.
The game ends when both players have made all possible substrings.

Scoring
A player gets +1 point for each occurrence of the substring in the string S.

For Example:
String S = BANANA
Kevin's vowel beginning word = ANA
Here, ANA occurs twice in BANANA. Hence, Kevin will get 2 Points.

For better understanding, see the image below:
https://s3.amazonaws.com/hr-challenge-images/9693/1450330231-04db904008-banana.png

Your task is to determine the winner of the game and their score.

Function Description

Complete the minion_game in the editor below.

minion_game has the following parameters:

- string string: the string to analyze

Prints

- string: the winner's name and score, separated by a space on one line, or Draw if there is no winner

Input Format

A single line of input containing the string S.
Note: The string will contain only uppercase letters: [A-Z] .

Constraints
0 < len(s) <= 10^6

Sample Input

BANANA

Sample Output

Stuart 12

Note :
Vowels are only defined as AEIOU . In this problem, Y is not considered a vowel.
"""


"""
so far as i can see that it one can do vowel and other one can do only Constraints, so that mean we can filter out through looks and add each unique letters.
so that mean we can use a sets since it is only accept the unique..

much much later...
i try but its kept having time out so i realized that O(N^2) wont works so that mean its need to be only first loops... but how?
after a bit some of research and came to realized that i could just do check first letter to confirm vowel or not then add that length of that substring to its total


so for example,
banana

start with index 0, so b is first, then we look if it not vowel, so it is, then we get length of it minus index
length - index and it return 6, then add it to total for non vowel stuart
then continue to next, till n which is also not vowel, so then again length - index (2) which give 4, so total is 10, so on...
why does this work instead of what solution shown in example where it check multi strings is due to that each substring does contain of each substrings.
e.g ban is part of banana,banan,bana
so when we just look for max... well you know it
"""
# from collections import Counter

# def counting_old(string,vowel=False):
#     kevin = Counter()
#     stuart = Counter()
#     vowel_list = "AEIOU"
#     for i in range(len(string)+1): 
#         for j in range(i+1,len(string) + 1):
#             current_block = string[i:j]
#             if current_block[0] in vowel_list:
#                 kevin[current_block] += 1
#             elif not current_block[0] in vowel_list: #no vowel then it is Constraints
#                 stuart[current_block] += 1
#             else: break
#     return [kevin,stuart]

def minion_game(string):
    vowel = "AEIOU"
    stuart = kevin = 0
    for i in range(len(string)):
        #we are getting rest of substring once we confirm initial letter is vowel or not.
        counter = len(string) - i
        if string[i] in vowel: kevin += counter
        else: stuart += counter

    if kevin == stuart: return print("Draw")
    elif kevin > stuart: return print(f"Kevin {kevin}")
    return print(f"Stuart {stuart}")

if __name__ == "__main__":
    s = input()
    minion_game(s)

