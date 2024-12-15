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


def find_order_from_point(point, seq, rules, visited):
    #print(f"inner...Looking at p:{point}, seq:{seq}., visited:{visited}")
    if point in visited:
        return []
    visited.append(point)
    if len(seq)==len(visited):
        #print(f"path found, visited:{visited}")
        return visited
    
    
    options = rules.get(point, ())
    options = tuple(opt for opt in options if opt in seq and opt not in visited)
    #print(point)
    #print(visited)
    #print(options)
    if options ==():
        return []
    for opt in options:
        result = find_order_from_point(opt, seq, rules, visited[:]) 
        if result:
            return result


    return []





def find_correct_order(seq, rules):
    for s in seq:
        #print(f"\ntrying point{s}")
        visited = find_order_from_point( s, seq, rules, [])
        if len(visited) == len(seq):
            return visited
        #print(f"outer...visited:{visited}")

def run_instructions(instr, rules):
    count = 0
    for inst in instr:
        #print(f"run instruction{inst}")
        middle = -1
        seq = inst.split(",")
        for i in range(len(seq)-1):
            j = i+1
            rule = rules.get(seq[i]) 
            if rule == None:
                #print(f"change order: {inst}")
                seq = find_correct_order(seq, rules)
                middle = len(seq) //2
                if middle != -1:
                    count += int(seq[middle])
                    break
            if seq[j] not in rule:
                #print(f"change order2: {inst}")
                seq = find_correct_order(seq, rules)
                middle = len(seq) //2
                if middle != -1:
                    count += int(seq[middle])
                break

    
    return count


def main():
    rule_dict, instr = parse_input("day5/full.txt")
    count = run_instructions(instr, rule_dict)
    print(count)

if __name__ == "__main__":
    main()