from functools import cmp_to_key


def parse_input(filename):
    with open(filename, "r") as f:
        lines = f.read()
        tmp = lines.split("\n\n")
        rules = tmp[0].split("\n")
        updates_str = tmp[1].split("\n")

        # finding smaller and bigger number (1-step)
        smaller_numbers = {}
        bigger_numbers = {}
        for rule in rules:
            tmp = rule.split("|")
            left_num = int(tmp[0])
            right_num = int(tmp[1])

            if left_num not in bigger_numbers:
                bigger_numbers[left_num] = set()
            bigger_numbers[left_num].add(right_num)
            if right_num not in smaller_numbers:
                smaller_numbers[right_num] = set()
            smaller_numbers[right_num].add(left_num)

            if right_num not in bigger_numbers:
                bigger_numbers[right_num] = set()
            if left_num not in smaller_numbers:
                smaller_numbers[left_num] = set()

        updates = []
        for update_str in updates_str:
            updates.append([int(num) for num in update_str.split(",")])

        return updates, bigger_numbers, smaller_numbers


def part1(filename):

    updates, bigger_numbers, smaller_numbers = parse_input(filename)

    res = 0
    for update in updates:
        curr_left = set()
        curr_right = set(update)
        valid = True
        for el in update:
            curr_right.remove(el)
            if len(curr_left - smaller_numbers[el]) > 0:
                valid = False
                break
            if len(curr_right - bigger_numbers[el]) > 0:
                valid = False
                break
            curr_left.add(el)
        if valid:
            res += update[len(update) // 2]

    print("Part 1 result: ", res)


def part2(filename):

    updates, bigger_numbers, smaller_numbers = parse_input(filename)

    ## iterative way to find all bigger numbers
    # for num, bigger_nums in bigger_numbers.items():
    #     stack = list(bigger_nums)
    #     visited = set()
    #     while stack:
    #         curr = stack.pop()
    #         if curr in visited:
    #             continue
    #         visited.add(curr)
    #         bigger_numbers[num] = bigger_numbers[num] + bigger_numbers[curr]
    #         stack.extend(bigger_numbers[curr] - visited)

    ## recursive way to find all bigger numbers
    completed_bigger_numbers = set()

    def complete_all_bigger_nums(num):
        if num not in completed_bigger_numbers:
            bigger_numbers[num].union(
                *(complete_all_bigger_nums(n) for n in bigger_numbers[num])
            )
            completed_bigger_numbers.add(num)
        return bigger_numbers[num]

    res = 0
    for update in updates:
        curr_left = set()
        curr_right = set(update)
        valid = True
        for el in update:
            curr_right.remove(el)
            if len(curr_left - smaller_numbers[el]) > 0:
                valid = False
                break
            if len(curr_right - bigger_numbers[el]) > 0:
                valid = False
                break
            curr_left.add(el)
        if not valid:
            # custom sorting where bigger means numbers that appear in bigger_numbers[x]
            sorted_update = sorted(
                update,
                key=cmp_to_key(lambda x, y: (-1 if y in bigger_numbers[x] else 1)),
                reverse=True,
            )
            res += sorted_update[len(sorted_update) // 2]

    print("Part 2 result: ", res)


part1("test.txt")
part1("input.txt")
part2("test.txt")
part2("input.txt")
