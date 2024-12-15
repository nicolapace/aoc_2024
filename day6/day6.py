import sys

sys.setrecursionlimit(15000)

directions = {
    "^": (-1, 0, ">"),
    ">": (0, 1, "v"),
    "v": (1, 0, "<"),
    "<": (0, -1, "^"),
}


def parse_input(filename):
    with open(filename, "r") as f:
        grid = [["Z"] + list(_) + ["Z"] for _ in f.read().split("\n")]
        grid.insert(0, ["Z"] * (len(grid[0])))
        grid.append(["Z"] * (len(grid[0])))

        for r, row in enumerate(grid):
            for c, el in enumerate(row):
                if el in ("^", ">", "v", "<"):
                    return grid, (r, c, el)


def print_grid(grid):
    for row in grid:
        print(" ".join(row))
    print()


def get_path(grid, start):

    path = set()

    ## recursive approach
    # def process_path(r, c):
    #     curr = grid[r][c]
    #     path.add((r, c))

    #     # print_grid(grid)

    #     dr, dc, next_angle = directions[curr]
    #     next_r, next_c = r + dr, c + dc

    #     if grid[next_r][next_c] == "#":
    #         grid[r][c] = next_angle
    #         process_path(r, c)
    #     elif grid[next_r][next_c] == "Z":
    #         # grid[next_r][next_c] = "O"
    #         return
    #     else:
    #         grid[next_r][next_c] = curr
    #         process_path(next_r, next_c)

    # # print_grid(grid)
    # process_path(start[0], start[1])

    ## iterative approach
    r, c, curr_angle = start
    while grid[r][c] != "Z":
        path.add((r, c))
        dr, dc, next_angle = directions[curr_angle]
        next_r, next_c = r + dr, c + dc

        if grid[next_r][next_c] == "#":
            curr_angle = next_angle
        else:
            r, c = next_r, next_c

    return path


def part1(filename):

    grid, start = parse_input(filename)

    print("Part 1 result: ", len(get_path(grid, start)))


def part2(filename):
    grid, start = parse_input(filename)

    def is_loop(start):
        path = set()

        ## recursive approach
        # def check_loop(r, c, curr_angle):
        #     if (r, c, curr_angle) in path:
        #         return 1
        #     path.add((r, c, curr_angle))

        #     dr, dc, next_angle = directions[curr_angle]
        #     next_r, next_c = r + dr, c + dc
        #     if grid[next_r][next_c] == "#":
        #         return check_loop(r, c, next_angle)
        #     elif grid[next_r][next_c] == "Z":
        #         return 0
        #     else:
        #         return check_loop(next_r, next_c, curr_angle)
        # return check_loop(*start)

        ## iterative approach
        r, c, curr_angle = start
        while grid[r][c] != "Z":
            if (r, c, curr_angle) in path:
                return 1
            path.add((r, c, curr_angle))
            dr, dc, next_angle = directions[curr_angle]
            next_r, next_c = r + dr, c + dc

            if grid[next_r][next_c] == "#":
                curr_angle = next_angle
            else:
                r, c = next_r, next_c
        return 0

    num_new_obstacles = 0
    for r, c in get_path(grid, start) - {(start[0], start[1])}:
        grid[r][c] = "#"
        num_new_obstacles += is_loop(start)
        grid[r][c] = "."

    # print_grid(grid)

    print("Part 2 result: ", num_new_obstacles)


# part1("test.txt")
# part1("input.txt")

# part2("test.txt")
part2("input.txt")
