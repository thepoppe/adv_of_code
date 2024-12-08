## Idea, create a dictonary of the rules.
## store the sequence in an array and run curr, prev through ruleset.

def parse_input(path):
    with open(path, "r") as file:
        content = file.read()
        rules, inst = content.split("\n\n")
        instructions = inst.split("\n")
        rules = rules.split("\n")
        dictionary ={}
        for i in range(len(rules)):
            key, val = rules[i].split("|")
            stored = dictionary.get(key)
            val = (val,)
            if stored != None:
                val = val + stored
            dictionary[key] = val
    return dictionary,instructions


def run_instructions(instr, rules):
    count = 0
    for inst in instr:
        middle = -1
        seq = inst.split(",")
        for i in range(len(seq)-1):
            j = i+1
            rule = rules.get(seq[i]) 
            if rule == None:
                middle = -1
                break
            if seq[j] not in rule:
                middle = -1
                break
            middle = len(seq) //2

        if middle != -1:
            count += int(seq[middle])
    
    return count


def main():
    rule_dict, instr = parse_input("day5/full.txt")
    count = run_instructions(instr, rule_dict)
    print(count)

if __name__ == "__main__":
    main()